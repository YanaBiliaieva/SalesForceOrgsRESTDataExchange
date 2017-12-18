@RestResource(urlMapping='/v1/updateContacts/*')
   global with sharing class UpdateContact {
    @HttpPut
    global static void UpdateContact() {
        RestRequest request = RestContext.request;
        JSONParser parser = JSON.createParser(EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString());
        Contact cont = new Contact();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')){
                System.debug('in While--2');  
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
                }
            }        
        }
 
        //String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        //System.debug('request.requestURI.substring =' +EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString());
        if(cont.Id!=null){
            List<Contact> thisContact = [SELECT Id FROM Contact WHERE Id = :cont.Id LIMIT 1];
            if(!thisContact.isEmpty()){
             try{
                update cont;
               }catch(Exception e){
                   System.debug(e.getMessage());
               }   
            } 
        }
        
        // Deserialize the JSON string into name-value pairs
        //Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
       // for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
        //    thisContact.put(fieldName, params.get(fieldName));
      //  }
        
    }    
   }