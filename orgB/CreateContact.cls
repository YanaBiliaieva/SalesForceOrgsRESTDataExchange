@RestResource(urlMapping='/v1/createContact/*')
   global with sharing class CreateContact {
    @HttpPOST
    global static void createContact() {
        RestRequest request = RestContext.request;
        JSONParser parser = JSON.createParser(EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString());
        Contact cont = new Contact();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'LastName')){
                parser.nextToken();
                String lastName=parser.getText();
                cont.put('LastName', parser.getText());
                System.debug('LastName=='+lastName);    
                parser.nextToken();
                while(parser.getCurrentToken() != null && (parser.getText() != 'LastName')&&(parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                        String field= parser.getText();
                    if(field!='Birthdate'){
                        parser.nextToken();
                        cont.put(field,String.valueOf(parser.getText()));
                        System.debug(field+'==='+ parser.getText() );  
                    } else{
                        parser.nextToken();
                        Date contactBirthdate= Date.valueOf(parser.getText());
                        cont.put('Birthdate',contactBirthdate);
                        System.debug('Birthdate=='+ contactBirthdate); 
                    }
                    parser.nextToken();           
                }
            }        
        }
            if(cont.LastName!=null){
             try{
                insert cont;
               }catch(Exception e){
                   System.debug(e.getMessage());
               }   
            } 
        }      
    }