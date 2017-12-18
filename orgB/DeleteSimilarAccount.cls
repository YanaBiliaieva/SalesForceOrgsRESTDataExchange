@RestResource(urlMapping='/v1/deleteSimilarAccount/*')
   global with sharing class DeleteSimilarAccount {
     @HttpDelete
      global static void deleteSimilarAccount(){
          RestRequest request = RestContext.request;
          String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
          Account thisAccount = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
          List<Case> relatedCases= [SELECT Id FROM Case WHERE AccountId = :thisAccount.Id];
          List<Opportunity> relatedOpportunities= [SELECT Id FROM Opportunity WHERE AccountId = :thisAccount.Id];
          try{
              delete relatedCases;
              delete relatedOpportunities;
               try{
                   delete thisAccount;
               }finally{
					System.debug('Account is deleted--'+thisAccount.Id);                   
               }
          }catch(Exception e){
                   System.debug('Error in deleteSimilarAccount--'+e.getMessage());
               }
      }
   }