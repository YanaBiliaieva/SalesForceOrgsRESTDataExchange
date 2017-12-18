@RestResource(urlMapping='/v1/deleteSimilarContact/*')
   global with sharing class DeleteSimilarContact {
     @HttpDelete
      global static void similarContacts(){
          RestRequest request = RestContext.request;
          String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
          Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
          delete thisContact;
      }
   }