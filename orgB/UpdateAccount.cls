@RestResource(urlMapping='/v1/updateAccount/*')
   global with sharing class UpdateAccount {
    @HttpPut
    global static void updateAccount() {
        RestRequest request = RestContext.request;
        JSONParser parser = JSON.createParser(EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString());
        Account acct = new Account();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')){
                System.debug('in While--2');  
                String fieldId= parser.getText();
                parser.nextToken();
                System.debug('in While--3'+'parser.getText();'+parser.getText());  
                acct.put(fieldId, parser.getText());
                System.debug('in While--4 AFTER ID PUT');  
                System.debug(fieldId+'@@@'+ parser.getText() );    
                parser.nextToken(); 
                }
                while(parser.getCurrentToken() != null && (parser.getText() != 'Id')&&(parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() != 'NumberOfEmployees')){
                        String field= parser.getText();
                        parser.nextToken();
                        acct.put(field,String.valueOf(parser.getText()));
                        System.debug('in While--5 AFTER PUT');  
                        System.debug(field+'@@@'+ parser.getText() );  
                    	parser.nextToken();           
                    }else{
                        System.debug('in While--NumberOfEmployees');  
                        parser.nextToken();
                        acct.put('NumberOfEmployees',Integer.valueOf(parser.getText()));
                        System.debug('in While--5 AFTER PUT');  
                        System.debug('NumberOfEmployees '+ parser.getText() );  
                    	parser.nextToken(); 
                    }
                }
            }        
        if(acct.Id!=null){
            List<Account> thisAccount = [SELECT Id FROM Account WHERE Id = :acct.Id LIMIT 1];
            if(!thisAccount.isEmpty()){
             try{
                update acct;
               }catch(Exception e){
                   System.debug(e.getMessage());
               }   
            } 
        }    
    }    
}