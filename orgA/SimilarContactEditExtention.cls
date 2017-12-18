global with sharing class SimilarContactEditExtention {
    global Contact contactForEdit{get;set;}
    global SimilarContactEditExtention (ApexPages.StandardController controller){
        contactForEdit=new Contact();
        contactForEdit.LastName=ApexPages.currentPage().getParameters().get('LastName');
        System.debug('contactLastName'+contactForEdit.LastName);
        contactForEdit.FirstName=ApexPages.currentPage().getParameters().get('FirstName');
        System.debug('contactFirstName'+contactForEdit.FirstName);
        contactForEdit.Email=ApexPages.currentPage().getParameters().get('Email');
        System.debug('contactEmail'+contactForEdit.Email);
        contactForEdit.Id=ApexPages.currentPage().getParameters().get('Id');
        System.debug('contactId'+contactForEdit.Id);
        try{
            contactForEdit.Birthdate=setStringToDateFormat(ApexPages.currentPage().getParameters().get('Birthdate'));
        }catch(Exception e){
            System.debug('contactBirthdate'+contactForEdit.Birthdate);
        }
        contactForEdit.AssistantName=ApexPages.currentPage().getParameters().get('AssistantName');
        System.debug('contactAssistantName'+contactForEdit.AssistantName);
        contactForEdit.Phone=ApexPages.currentPage().getParameters().get('Phone');
        System.debug('contactPhone'+contactForEdit.Phone);
        contactForEdit.HomePhone=ApexPages.currentPage().getParameters().get('HomePhone');
        System.debug('contactHomePhone'+contactForEdit.HomePhone);
        contactForEdit.MobilePhone=ApexPages.currentPage().getParameters().get('MobilePhone');
        System.debug('contactMobilePhone'+contactForEdit.MobilePhone);
        contactForEdit.Fax=ApexPages.currentPage().getParameters().get('Fax');
        System.debug('contactFax'+contactForEdit.Fax);
        contactForEdit.Title=ApexPages.currentPage().getParameters().get('Title');
        System.debug('contactTitle'+contactForEdit.Title);
        contactForEdit.MailingCity=ApexPages.currentPage().getParameters().get('MailingCity');
        System.debug('contactMailingCity'+contactForEdit.MailingCity);
        contactForEdit.MailingState=ApexPages.currentPage().getParameters().get('MailingState');
        System.debug('contactMailingState'+contactForEdit.MailingState);
        contactForEdit.MailingCountry=ApexPages.currentPage().getParameters().get('MailingCountry');
        System.debug('contactMailingCountry'+contactForEdit.MailingCountry);
        contactForEdit.MailingPostalCode=ApexPages.currentPage().getParameters().get('MailingPostalCode');
        System.debug('contactMailingPostalCode'+contactForEdit.MailingPostalCode);
      System.debug('ApexPages.currentPage().getParameters().get access_token==='+ApexPages.currentPage().getParameters().get('access_token'));   
    }
    private Date setStringToDateFormat(String myDate) {
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = Integer.valueOf(strDate[1]);
        Integer myIntMonth = Integer.valueOf(strDate[0]);
        Integer myIntYear = Integer.valueOf(strDate[2]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
}
    public PageReference saveContact(){
        SendContactNameUsingRestApi.callUpdateSimilarContact(contactForEdit);
        System.debug('contact id To Update is---'+contactForEdit.Id);
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
