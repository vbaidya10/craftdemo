({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        if(recId.startsWith('500')){
            component.set("v.isCase",true);
        }
        var action = component.get("c.getAccountDetails");
        action.setParams({
            'recId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                var cardNo = returnVal.Card_Number__c;
                if(cardNo!=null && cardNo!='')
                    component.set("v.cardNumber","XXXX-XXXX-XXXX-"+cardNo.slice(-4));
                component.set("v.acc",returnVal);
                if(returnVal.Courier_Tracking__r != null){
                    component.set("v.tracking",returnVal.Courier_Tracking__r[0]);
                    component.set("v.headerText","Courier Tracking System");
                }
                if(returnVal.Tracking_Id__c != null && returnVal.Account_Courier_Status__c != 'Delivered'){
                    helper.pullCourierStatus(component, event, helper, returnVal.Tracking_Id__c);
                }
                component.set("v.isLoaded",true);
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    scheduleTracking : function(component, event, helper) {
        if(component.find("scheduleDate").get("v.value") == ''){
            helper.toastMsg("Please select Date.","warning");
            return;
        }else if(component.find("scheduleTime").get("v.value") == ''){
            helper.toastMsg("Please select Time.","warning");
            return;
        }
        var trackingSfId = (component.get("v.tracking")==null)?'':component.get("v.tracking").Id;
        var action = component.get("c.createOrUpdateTracking");
        action.setParams({
            'accId': component.get("v.acc").Id,
            'trackingId': trackingSfId,
            'scheduledDate': component.find("scheduleDate").get("v.value"),
            'scheduledTime': component.find("scheduleTime").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                component.set("v.tracking",returnVal);
                component.set("v.headerText","Courier Tracking System");
                component.set("v.acc.Account_Courier_Status__c","Scheduled");
                $A.get('e.force:refreshView').fire();
                helper.toastMsg("Courier Scheduled Successfully!","success");
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    reset : function(component, event, helper) {
        component.find("scheduleDate").set("v.value","");
        component.find("scheduleTime").set("v.value","");
    },
    
    confirmPickup : function(component, event, helper) {
        var action = component.get("c.confirmCourierPickup");
        action.setParams({
            'trackingId': component.get("v.tracking").Id,
            'accId': component.get("v.acc").Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                if(returnVal=='dispatched'){
                    component.set("v.tracking.Status__c","Dispatched");
                    $A.get('e.force:refreshView').fire();
                    helper.toastMsg("Courier Dispatched Successfully!","success");
                    helper.invokeCourierService(component, event, helper, component.get("v.acc").Id, component.get("v.tracking").Id);
                }
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    reschedule : function(component, event, helper) {
        component.set("v.headerText","Courier Schedule System");
        component.set("v.acc.Account_Courier_Status__c",null);
    },
    
    refreshCourierStatus : function(component, event, helper) {
        var acc = component.get("v.acc");
        helper.pullCourierStatus(component, event, helper, acc.Tracking_Id__c);
    }
    
})