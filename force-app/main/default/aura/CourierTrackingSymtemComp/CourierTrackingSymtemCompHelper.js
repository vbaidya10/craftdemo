({
    toastMsg : function(msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": msg,
            "type": "success"
        });
        toastEvent.fire();
    },
    
    invokeCourierService : function(component, event, helper, accId, trackingId) {
        var action = component.get("c.callCourierService");
        action.setParams({
            'trackingId': component.get("v.tracking").Id,
            'accId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                var arr_from_json = JSON.parse(returnVal);
                component.set("v.acc.Tracking_Id__c",arr_from_json.TrackingId);
                var allStatus = JSON.parse(arr_from_json.AllStatus);
                helper.parseAllStatus(component, event, helper, allStatus);
                $A.get('e.force:refreshView').fire();
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    pullCourierStatus : function(component, event, helper, tId) {
        var action = component.get("c.getCourierStatus");
        action.setParams({
            'trackingId': tId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                var arr_from_json = JSON.parse(returnVal);
                var allStatus = JSON.parse(arr_from_json.AllStatus);
                helper.parseAllStatus(component, event, helper, allStatus);
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    parseAllStatus : function(component, event, helper, allStatus) {
        var statusArray = [];
        var statusDeliveredObj;
        var getLocationObj;
        for(var i=0;i<allStatus.length;i++){
            var obj = allStatus[i];
            var statusObj = {};
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    var val = obj[key];
                    statusObj[key] = val;
                }
            }
            if(statusObj.Status__c=='Delivered'){
                statusDeliveredObj=statusObj;
            }
            if(i==(allStatus.length-1)){
                getLocationObj=statusObj;
            }
            statusArray.push(statusObj);
        }
        component.set("v.statusList",statusArray);
        if(getLocationObj != null){
            component.set("v.loadMap",false);
            component.set("v.source",statusObj.Courier__r.Source_Location__c);
            component.set("v.destination",statusObj.Courier__r.Destination_Location__c);
            component.set("v.currentLocation",statusObj.From_Location__c);
            component.set("v.loadMap",true);
        }
        if(statusDeliveredObj != null){
            helper.markCourierAsDelivered(component, event, helper, statusDeliveredObj.Courier__r.Received_By__c, statusDeliveredObj.Courier__r.ReceivedBy_Phone__c);
        }
    },
    
    markCourierAsDelivered : function(component, event, helper, receivedBy, receivedByPhone) {
        var action = component.get("c.setCourierAsDelivered");
        action.setParams({
            'trackingId': component.get("v.tracking").Id,
            'accId': component.get("v.recordId"),
            'receivedBy': receivedBy,
            'receivedByPhone': receivedByPhone
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            if(state === "SUCCESS") {
                if(returnVal=='delivered'){
                    component.set("v.tracking.Status__c","Delivered");
                    component.set("v.acc.Account_Courier_Status__c","Delivered");
                    $A.get('e.force:refreshView').fire();
                    helper.toastMsg("Courier Delivered Successfully!");
                }
            }
            else if(state === "ERROR"){
                alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})