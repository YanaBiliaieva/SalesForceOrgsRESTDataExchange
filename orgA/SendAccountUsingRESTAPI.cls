public class SendAccountUsingRESTAPI {
   private static final String clientId = '';
   private static final String clientSecret = '';
   private static final String username = '';
   private static final String password = ''; 
   private static final String similarAccountsEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/getSimilarAccounts/';
   private static final String deleteSimilarAccountEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/deleteSimilarAccount/';
   private static final String updateSimilarAccountEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/updateAccount/';
   private static final String createAccountEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/createAccount/';   
   private static final String oauthEndPoint =  'https://eu9.salesforce.com/services/oauth2/token';
    class DeserializeResponse{
      public String id; 
      public String access_token;
    }
    public static String returnAccessToken (){
        String reqbody ='grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Http htp = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(oauthEndPoint);
        HttpResponse res = htp.send(req);
        DeserializeResponse resp1 = (DeserializeResponse)JSON.deserialize(res.getbody(),DeserializeResponse.class);
        return resp1.access_token;
   }

   public static List<Account> similarAccounts (String accountName){
       String accessToken = returnAccessToken ();
       System.debug('accountName!!!!!!!!!!!!+++++++'+accountName);
       List<Account> lstAccount=new List<Account>();
       if(accessToken != null){
       String endPoint = similarAccountsEndPoint +accountName;
       Http h2 = new Http();
       HttpRequest req1 = new HttpRequest();
       req1.setHeader('Authorization','Bearer ' + accessToken);
       req1.setHeader('Content-Type','application/json');
       req1.setHeader('accept','application/json');
       req1.setMethod('GET');
       req1.setEndpoint(endPoint);
       HttpResponse res1 = h2.send(req1);
       String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
       System.debug('@@@RESPONSE@@'+trimmedResponse);  
       lstAccount=responseParser(res1);
       }
       return lstAccount;
}
   public static void deleteSimilarAccount (Id accountToDelete){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            String endPoint = deleteSimilarAccountEndPoint+accountToDelete;
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('DELETE');
            req1.setEndpoint(endPoint);
            htp.send(req1);
        }else{
            System.debug('AccessToken in void deleteSimilarAccount ---is null---');
        }
    }
     public static void callUpdateSimilarAccount(Account accountToUpdate){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            gen.writeStartObject();   
            gen.writeStringField('Id', accountToUpdate.Id);
            if(accountToUpdate.Name!=null)
            gen.writeStringField('Name', accountToUpdate.Name);
            if(accountToUpdate.Website!=null)
            gen.writeStringField('Website', accountToUpdate.Website);
            if(accountToUpdate.Phone!=null)
            gen.writeStringField('Phone', accountToUpdate.Phone);
            if(accountToUpdate.Description!=null)
            gen.writeStringField('Description', accountToUpdate.Description);
            if(accountToUpdate.Phone!=null)
            gen.writeStringField('Phone', accountToUpdate.Phone);
            if(accountToUpdate.Fax!=null)
            gen.writeStringField('Fax', accountToUpdate.Fax);
            if(accountToUpdate.NumberOfEmployees!=null)
            gen.writeStringField('NumberOfEmployees', String.valueOf(accountToUpdate.NumberOfEmployees));
            if(accountToUpdate.Description!=null)
            gen.writeStringField('Description', accountToUpdate.Description);
            gen.writeEndObject();
            gen.writeEndArray();
            String accountToUpdateString = gen.getAsString();
            System.debug('accountToUpdateString: ' + accountToUpdateString );
            String endPoint = updateSimilarAccountEndPoint;
            System.debug('endPoint==='+endPoint);
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('PUT');
            req1.setBody(accountToUpdateString);
            req1.setEndpoint(endPoint);         
            HttpResponse response=htp.send(req1);
        }else{
            System.debug('AccessToken in void callUpdateAccountContact ---is null---');
        }
    } 
    public static List<Account> responseParser(HttpResponse res1){
        JSONParser parser = JSON.createParser(res1.getBody());
        List<Account> lstAccount=new List<Account>();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')){
                System.debug('in While--2');  
                Account acct = new Account();
                String fieldId= parser.getText();
                parser.nextToken();
                System.debug('in While--3 NOT DATE'+'parser.getText();'+parser.getText());  
                acct.put(fieldId, parser.getText());
                System.debug('in While--4 AFTER ID PUT');  
                System.debug(fieldId+'@@@'+ parser.getText() );    
                parser.nextToken();
                while(parser.getCurrentToken() != null && (parser.getText() != 'Id')&&(parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String field= parser.getText();
                    if(field=='NumberOfEmployees'){
                        parser.nextToken();
                        acct.put(field,Integer.valueOf(parser.getText()));
                        System.debug('in While--5 AFTER PUT');  
                        System.debug(field+'@@@'+ parser.getText() );   
                    }else{
                        parser.nextToken();
                        acct.put(field,String.valueOf(parser.getText()));
                        System.debug('in While--5 AFTER PUT');  
                        System.debug(field+'@@@'+ parser.getText() );   
                        parser.nextToken();  
                    }
                }lstAccount.add(acct);
            }   
        }return lstAccount;
    }
    public static void createAccount(Account acct){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            gen.writeStartObject();   
            if(acct.Name!=null){
                String name=acct.Name.replace(' ', '+');
                gen.writeStringField('Name', name);
                System.debug('name with plus'+name);
            }            
            if(acct.Website!=null)
            gen.writeStringField('Website', acct.Website);
            if(acct.Phone!=null)
            gen.writeStringField('Phone', acct.Phone);
            if(acct.Fax!=null)
            gen.writeStringField('Fax', acct.Fax);
            if(acct.NumberOfEmployees!=null)
            gen.writeStringField('NumberOfEmployees', String.valueOf(acct.NumberOfEmployees));
            if(acct.Description!=null)
            gen.writeStringField('Description', acct.Description);
            gen.writeEndObject();
            gen.writeEndArray();
            String accountToCreateString = gen.getAsString();
            System.debug('accountToCreateString: ' + accountToCreateString );
            System.debug('endPoint==='+createAccountEndPoint);
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('POST');    
            req1.setBody(accountToCreateString);
            req1.setEndpoint(createAccountEndPoint);
            HttpResponse response=htp.send(req1);
        }else{
            System.debug('AccessToken in void create Contact ---is null---');
        }
    }
}
