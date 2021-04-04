public class CourierTrackingSystemController {
    @AuraEnabled
    public static Account getAccountDetails(string recId){
        try{
            if(recId.startsWith('500')){
                recId=[select AccountId from Case where Id=: recId].AccountId;
            }
            return [select Id,Name,Card_Number__c,Account_Courier_Status__c,Tracking_Id__c, 
                    (select Id,Date__c,format(Time__c) formatedTime,Status__c from Courier_Tracking__r where Status__c IN ('Scheduled','Dispatched') LIMIT 1) 
                    from Account where Id =: recId];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Courier_Tracking__c createOrUpdateTracking(string trackingId, string accId, string scheduledDate, string scheduledTime){
        trackingId = (trackingId=='')?null:trackingId;
        Courier_Tracking__c cT = new Courier_Tracking__c(Id=trackingId, Account__c=accId, Status__c='Scheduled', Dispatched_On__c=null);
        cT.Date__c = Date.valueOf(scheduledDate);
        String[] strTimeSplit = scheduledTime.split(':');
        Time scheduledTimeFormatted = Time.newInstance(Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),0,0);
        cT.Time__c = scheduledTimeFormatted;
        try{
            upsert cT;
            Account a = new Account(Id=accId,Account_Courier_Status__c='Scheduled',Tracking_Id__c='');
            update a;
            cT = [select Id,Date__c,format(Time__c) formatedTime,Status__c from Courier_Tracking__c where Id =: cT.Id];
            return cT;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string confirmCourierPickup(string trackingId, string accId){
        try{
            Account a = new Account(Id=accId,Account_Courier_Status__c='Dispatched');
            update a;
            Courier_Tracking__c cT = new Courier_Tracking__c(Id=trackingId,Status__c='Dispatched',Dispatched_On__c=System.today());
            update cT;
            return 'dispatched';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string setCourierAsDelivered(string trackingId, string accId, string receivedBy, string receivedByPhone){
        try{
            Courier_Tracking__c cT = new Courier_Tracking__c(Id=trackingId, Status__c='Delivered', Received_By__c=receivedBy, ReceivedBy_Phone__c=receivedByPhone);
            update cT;
            Account a = new Account(Id=accId,Account_Courier_Status__c='Delivered',Account_Status__c='Active');
            update a;
            return 'delivered';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string getCourierStatus(string trackingId){
        try{
            return CourierAPICall.api_get(trackingId);
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string callCourierService(string trackingId, string accId){
        try{
            return CourierAPICall.api_post(accId+'#'+trackingId+'#'+system.now(), UserInfo.getName(), '9832049910', 'Delhi', 'Patna');
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}