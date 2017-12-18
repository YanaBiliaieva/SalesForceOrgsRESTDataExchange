public class SendContactNameUsingRestApi {
   private static final String clientId = '';
   private static final String clientSecret = '';
   private static final String username = '';
   private static final String password = ''; 
   private static final String similarContactsEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/getSimilarContacts/';
   private static final String deleteSimilarContactEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/deleteSimilarContact/';
   private static final String updateSimilarContactEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/updateContacts/';
   private static final String createSimilarContactEndPoint = 'https://eu9.salesforce.com/services/apexrest/v1/createContact/';   
   private static final String oauthEndPoint =  'https://eu9.salesforce.com/services/oauth2/token';
    class DeserializeResponse{
      public String id;
      public String access_token;
   }
    public static String returnAccessToken (){
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(oauthEndPoint);
        HttpResponse res = h.send(req);
        DeserializeResponse resp1 = (DeserializeResponse)JSON.deserialize(res.getbody(),DeserializeResponse.class);
        System.debug('@@@@access_token@@'+resp1 );
        return resp1.access_token;
   }
    
   public static List<Contact> callGetSimilarContacts (String receivedContactName){
       String accessToken = returnAccessToken ();
       List<Contact> lstContact=new List<Contact>();
       if(accessToken != null){
           String endPoint = similarContactsEndPoint +receivedContactName;
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
           lstContact=ResponseParser(res1);

   }
       return lstContact;
}
    public static List<Contact> ResponseParser(HttpResponse res1){
        JSONParser parser = JSON.createParser(res1.getBody());
        List<Contact> lstContact=new List<Contact>();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')){
                System.debug('in While--2');  
                Contact cont = new Contact();
                String fieldId= parser.getText();
                parser.nextToken();
                System.debug('in While--3 NOT DATE'+'parser.getText();'+parser.getText());  
                cont.put(fieldId, parser.getText());
                System.debug('in While--4 AFTER ID PUT');  
                System.debug(fieldId+'@@@'+ parser.getText() );    
                parser.nextToken();
                while(parser.getCurrentToken() != null && (parser.getText() != 'Id')&&(parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                        String field= parser.getText();
                    if(field!='Birthdate'){
                        parser.nextToken();
                        cont.put(field,String.valueOf(parser.getText()));
                        System.debug('in While--5 AFTER PUT');  
                        System.debug(field+'@@@'+ parser.getText() );  
                    } else{
                        parser.nextToken();
                        Date contactBirthdate= Date.valueOf(parser.getText());
                        cont.put(field,contactBirthdate);
                        System.debug('in While--6 Birthdate AFTER PUT');  
                        System.debug(field+'@@@'+ contactBirthdate ); 
                    }
                    parser.nextToken();           
                }lstContact.add(cont);
            } 
           
        }return lstContact;
    }
	public static void callDeleteSimilarContact(Id contactToDelete){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            String endPoint = deleteSimilarContactEndPoint+contactToDelete;
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('DELETE');
            req1.setEndpoint(endPoint);
            htp.send(req1);
        }else{
            System.debug('AccessToken in void callDeleteSimilarContact ---is null---');
        }
    }
        public static void callUpdateSimilarContact(Contact contactToUpdate){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            gen.writeStartObject();   
            gen.writeStringField('Id', contactToUpdate.Id);
            if(contactToUpdate.LastName!=null)
            gen.writeStringField('LastName', contactToUpdate.LastName);
            if(contactToUpdate.FirstName!=null)
            gen.writeStringField('FirstName', contactToUpdate.FirstName);
            if(contactToUpdate.Email!=null)
            gen.writeStringField('Email', contactToUpdate.Email);
            if(contactToUpdate.Department!=null)
            gen.writeStringField('Department', contactToUpdate.Department);
            if(contactToUpdate.Birthdate!=null)
            gen.writeStringField('Birthdate', String.valueOf(contactToUpdate.Birthdate));
            if(contactToUpdate.AssistantName!=null)
            gen.writeStringField('AssistantName', contactToUpdate.AssistantName);
            if(contactToUpdate.AssistantPhone!=null)
            gen.writeStringField('AssistantPhone', contactToUpdate.AssistantPhone);
            if(contactToUpdate.Description!=null)
            gen.writeStringField('Description', contactToUpdate.Description);
            if(contactToUpdate.Phone!=null)
            gen.writeStringField('Phone', contactToUpdate.Phone);
            if(contactToUpdate.HomePhone!=null)
            gen.writeStringField('HomePhone', contactToUpdate.HomePhone);
            if(contactToUpdate.MobilePhone!=null)
            gen.writeStringField('MobilePhone', contactToUpdate.MobilePhone);
            if(contactToUpdate.Fax!=null)
            gen.writeStringField('Fax', contactToUpdate.Fax);
            if(contactToUpdate.Title!=null)
            gen.writeStringField('Title', contactToUpdate.Title);
            if(contactToUpdate.MailingCity!=null)
            gen.writeStringField('MailingCity', contactToUpdate.MailingCity);
            if(contactToUpdate.MailingState!=null)
            gen.writeStringField('MailingState', contactToUpdate.MailingState);
            if(contactToUpdate.MailingCountry!=null)
            gen.writeStringField('MailingCountry', contactToUpdate.MailingCountry);
            if(contactToUpdate.MailingPostalCode!=null)
            gen.writeStringField('MailingPostalCode', contactToUpdate.MailingPostalCode);
            gen.writeEndObject();
            gen.writeEndArray();
            String contactToUpdateString = gen.getAsString();
            System.debug('contactToUpdateString: ' + contactToUpdateString );
            //contactToUpdateString='name';
            String endPoint = updateSimilarContactEndPoint;
            System.debug('endPoint==='+endPoint);
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('PUT');
            req1.setBody(contactToUpdateString);
            req1.setEndpoint(endPoint);         
            HttpResponse response=htp.send(req1);
        }else{
            System.debug('AccessToken in void callUpdateSimilarContact ---is null---');
        }
    }
    public static void callCreateContact(Contact cont){
        String accessToken = returnAccessToken ();
        if(accessToken != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            gen.writeStartObject();   
            if(cont.LastName!=null)
            gen.writeStringField('LastName', cont.LastName);
            if(cont.FirstName!=null)
            gen.writeStringField('FirstName', cont.FirstName);
            if(cont.Email!=null)
            gen.writeStringField('Email', cont.Email);
            if(cont.Department!=null)
            gen.writeStringField('Department', cont.Department);
            if(cont.Birthdate!=null)
            gen.writeStringField('Birthdate', String.valueOf(cont.Birthdate));
            if(cont.Description!=null)
            gen.writeStringField('Description', cont.Description);
            if(cont.Phone!=null)
            gen.writeStringField('Phone', cont.Phone);
            if(cont.HomePhone!=null)
            gen.writeStringField('HomePhone', cont.HomePhone);
            if(cont.MobilePhone!=null)
            gen.writeStringField('MobilePhone', cont.MobilePhone);
            if(cont.Fax!=null)
            gen.writeStringField('Fax', cont.Fax);
            if(cont.Title!=null)
            gen.writeStringField('Title', cont.Title);
            gen.writeEndObject();
            gen.writeEndArray();
            String contactToCreateString = gen.getAsString();
            System.debug('contactToCreateString: ' + contactToCreateString );
            String endPoint = createSimilarContactEndPoint;
            System.debug('endPoint==='+endPoint);
            Http htp = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' + accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('POST');
            req1.setBody(contactToCreateString);
            req1.setEndpoint(endPoint);         
            HttpResponse response=htp.send(req1);
        }else{
            System.debug('AccessToken in void callUpdateSimilarContact ---is null---');
        }
    }
}
