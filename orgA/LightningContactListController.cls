global class LightningContactListController {
    @AuraEnabled
    global static List<Contact> getContacts(Id recordId) {
        String contactName;
        List <Contact> similarContactsList;
        List<Contact> contactPageName = [SELECT LastName FROM Contact WHERE Id = :recordId LIMIT 1];
        if(!contactPageName.isEmpty()){
          contactName=contactPageName[0].LastName; 
        }
        System.debug('--------contactName is---'+contactName);
        similarContactsList=SendContactNameUsingRestApi.callGetSimilarContacts(contactName);  
        System.debug('--------similarContactsList is---empty?'+similarContactsList.isEmpty());
        return similarContactsList;
    }
    @AuraEnabled
    global static Id deleteContact(Id contactToDelete) {
        try{
            SendContactNameUsingRestApi.callDeleteSimilarContact(contactToDelete);
        }catch(Exception e){
            System.debug('callDeleteSimilarContact Exception'+e.getMessage());
        }
        return contactToDelete;
    }
}