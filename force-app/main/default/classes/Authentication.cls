global class Authentication {
    global static string getToken(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('POST');
        req.setEndpoint('https://mycourier-dev-ed.my.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fe4g9fhX0E4udIhRLileLoGKr3ITJzCgxKmE7HOzz9Mr6NLf5.XJhdmqQtIMetqGcAA98hddlFdIqXtK&client_secret=5A08E11265F13D6F9524EEE03FD602CD8F3E1C77F25512808D9566F07521BED3&username=vivek@tracking.com&password=Maxpl0re@123EFM2nZefg8OLOEwy7wBugsLn');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res = http.send(req);
        return res.getBody();
    }
}