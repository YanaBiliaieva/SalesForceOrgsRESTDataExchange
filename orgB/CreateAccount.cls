@RestResource(urlMapping='/v1/createAccount/*')
   global with sharing class CreateAccount {
    @HttpPOST
    global static void createAccount() {
        RestRequest request = RestContext.request;
        JSONParser parser = JSON.createParser(EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString());
        Account acct = new Account();
        while (parser.nextToken() != null) {   
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')){
                parser.nextToken();
                System.debug('Name=='+parser.getText());  
                String name=parser.getText().replace('+', ' ');
                acct.put('Name',name); 
                parser.nextToken();
                while(parser.getCurrentToken() != null && (parser.getText() != 'Name')&&(parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    if (parser.getText() == 'NumberOfEmployees'){
                        parser.nextToken();
                        Integer num=Integer.valueOf(parser.getText());
                        acct.put('NumberOfEmployees',num);
                        System.debug('NumberOfEmployees'+num);  
                    }else{
                        String field= parser.getText();
                        parser.nextToken();
                        acct.put(field,String.valueOf(parser.getText()));
                        System.debug(field+'===='+ parser.getText() );  
                    	parser.nextToken();  
                    }
                }
            }        
        }
        if(acct.Name!=null){
            try{
                insert acct;
            }catch(Exception e){
                   System.debug(e.getMessage());
            }   
        }    
   }    
}