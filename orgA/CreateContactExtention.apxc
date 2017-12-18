global with sharing class CreateContactExtention {
    global Contact contactForCreation{get;set;}
    global CreateContactExtention (ApexPages.StandardController controller){
        contactForCreation=new Contact();
      
    }
      public PageReference createContact(){
          SendContactNameUsingRestApi.callCreateContact(contactForCreation);
          PageReference similarContactsPage= new PageReference('/apex/similarContacts');
          similarContactsPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('currentContactId'));
          similarContactsPage.setRedirect(true);
          return similarContactsPage;
        }
       public PageReference returnPage(){
        PageReference similarContactsPage= new PageReference('/apex/similarContacts');
        similarContactsPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('currentContactId'));
        similarContactsPage.setRedirect(true);
        return similarContactsPage;
    }
}
