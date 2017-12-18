@RestResource(urlMapping='/v1/getSimilarContacts/*')
   global with sharing class GetSimilarContact {
     @HttpGet
      global static List<Contact> similarContacts(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String receivedContactName=req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
          List<Contact> lstContact;
          if(receivedContactName!=null){
              receivedContactName = receivedContactName.replace('+',' ');
              String contactLastName= '%'+receivedContactName+'%';
              List<String >receivedContactNames = receivedContactName.split(' ');        
              if(receivedContactNames.size()>1){
                  for(Integer i=0;i<receivedContactNames.size();i++){
                      receivedContactNames[i]='%'+receivedContactNames[i]+'%'; 
                  }
                  lstContact =[SELECT Id,LastName,FirstName, Email, Department, Birthdate,
                                   Description, Phone, HomePhone, MobilePhone, Fax, Title   
                                   FROM Contact WHERE LastName  LIKE :receivedContactNames OR FirstName LIKE :receivedContactNames];
                  return lstContact;
              }else {
                  System.debug('receivedContactName==='+receivedContactName);
                  lstContact =[SELECT Id,LastName,FirstName, Email, Department, Birthdate,
                                   Description, Phone, HomePhone, MobilePhone, Fax, Title   
                                   FROM Contact WHERE LastName LIKE :receivedContactName OR FirstName LIKE :receivedContactName];
                  return lstContact;
              }   
          }System.debug('receivedContactName==null');
          return lstContact;
      }
   }
