public with sharing class SimilarContactsControllerExtention {
    public  List <Contact> similarContactsList{get;set;}
    public String contactName {get;set;}
    public Id contactToEditId{get;set;}
    public String contactToDeleteId{get;set;}
    public Id selectedContactId{set;get;}
    public String currentContactId {set;get;}
    
    public SimilarContactsControllerExtention(ApexPages.StandardController controller){
        currentContactId=ApexPages.currentPage().getParameters().get('id');
        if(currentContactId==null){
            currentContactId=ApexPages.currentPage().getParameters().get('currentContactId');
        }
        getContent(currentContactId);
     } 
    public void getContent(String currentContactId){
        List<Contact> contactPageName = [SELECT LastName, FirstName FROM Contact WHERE Id = :currentContactId LIMIT 1];
        if(!contactPageName.isEmpty()){
            contactName=contactPageName[0].LastName;
            if(contactPageName[0].FirstName!=null)
                contactName=contactName+' '+contactPageName[0].FirstName; 
                contactName=contactName.replace(' ', '+');
            System.debug('contactName='+contactName);
        }
         similarContactsList=SendContactNameUsingRestApi.callGetSimilarContacts(contactName);
    }
    public PageReference editSimilarContact(){
        selectedContactId = Apexpages.currentPage().getParameters().get('contactToEditId');
        List <String> fieldsNames= new List <String>{'Id','LastName','FirstName', 'Email', 'Department', 'Birthdate', 'AssistantName',
                                   'AssistantPhone', 'Description', 'Phone', 'HomePhone', 'MobilePhone', 'Fax', 'Title', 
                                   'MailingCity', 'MailingState', 'MailingCountry','MailingPostalCode'};
		PageReference contactEditPage= new PageReference('/apex/contactEditPage');
        contactEditPage.setRedirect(true);
        if(selectedContactId!=null){
			String strName;
            for( Integer j=0;j<similarContactsList.size();j++){
                System.debug('IN editSimilarContact=====(String)similarContactsList[j].Id===='+(String)similarContactsList[j].Id);
                System.debug('IN editSimilarContact=====selectedContactId===='+selectedContactId);
                if(((String)similarContactsList[j].Id).contains(selectedContactId)){
                    for(Integer k=0;k<fieldsNames.size();k++){
                        strName=fieldsNames[k];
                        String strValue=String.valueOf(similarContactsList[j].get(strName));
                        contactEditPage.getParameters().put(strName, strValue);
                        System.debug(strName+strValue);
                    }    
                }   
            }
        }      
        System.debug('--------selectedContactId is---'+selectedContactId);
        if(ApexPages.currentPage().getParameters().get('id')==null){
            contactEditPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('currentContactId'));    
        }else{
            contactEditPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('id')); 
        } 
        return contactEditPage;
       }
    public void deleteSimilarContact(){
            Id contactToDelete= Apexpages.currentPage().getParameters().get('contactToDeleteId');
        	System.debug('contact id To Delete is---'+contactToDelete);
            SendContactNameUsingRestApi.callDeleteSimilarContact(contactToDelete);
            getContent(currentContactId);
        }
    public PageReference createContact(){
        PageReference createContactPage= new PageReference('/apex/createContact');
        if(ApexPages.currentPage().getParameters().get('id')==null){
         createContactPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('currentContactId'));    
        }else{
           createContactPage.getParameters().put('currentContactId', ApexPages.currentPage().getParameters().get('id')); 
        } 
        createContactPage.setRedirect(true);
        return createContactPage;
    }
}
