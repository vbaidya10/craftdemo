global class CourierAPICall {
    global static string api_post(string externalId,string initiatedBy,string initiatedByPhone,string sourceAddress,string destinationAddress){
        JSONGenerator genPost = JSON.createGenerator(true);
        genPost.writeStartObject();
        genPost.writeStringField('externalId', externalId);
        genPost.writeStringField('initiatedBy', initiatedBy);
        genPost.writeStringField('initiatedByPhone', initiatedByPhone);
        genPost.writeStringField('sourceAddress', sourceAddress);
        genPost.writeStringField('destinationAddress', destinationAddress);
        genPost.writeEndObject();
        genPost.close();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String tokenString = Authentication.getToken();
        String token;
        String instanceURL;
        if(tokenString.contains('access_token')){
            JSONParser parser = JSON.createParser(tokenString);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    token = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'instance_url')) {
                    parser.nextToken();
                    instanceURL = parser.getText();
                }    
            } 
        }        
        req.setMethod('POST'); 
        req.setEndpoint(instanceURL+'/services/apexrest/CourierService');
        req.setHeader('Authorization', 'Bearer '+ token);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(genPost.getAsString()); 
        res = http.send(req);
        String resBody = res.getBody();
        String trackingId;
        if(resBody.contains('TrackingId')){
            JSONParser par = JSON.createParser(resBody);
            while (par.nextToken() != null) {
                if (par.getText() == 'TrackingId') {
                    par.nextToken();
                    trackingId = par.getText();
                    break;
                }
            }
        }
        string accId = externalId.split('#')[0];
        Account a = new Account(Id=accId,Tracking_Id__c=trackingId);
        Update a;
        return res.getBody();
    }
    
    global static string api_get(string trackingId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String tokenString = Authentication.getToken();
        String token;
        String instanceURL;
        if(tokenString.contains('access_token')){
            JSONParser parser = JSON.createParser(tokenString);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    token = parser.getText();
                }
                else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'instance_url')) {
                    parser.nextToken();
                    instanceURL = parser.getText();
                }    
            } 
        }        
        req.setMethod('GET'); 
        req.setEndpoint(instanceURL+'/services/apexrest/CourierService/'+trackingId);
        req.setHeader('Authorization', 'Bearer '+ token);
        req.setHeader('Content-Type', 'application/json');
        res = http.send(req);
        return res.getBody();
    }
}