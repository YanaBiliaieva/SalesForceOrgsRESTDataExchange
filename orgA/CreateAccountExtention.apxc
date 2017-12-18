global with sharing class CreateAccountExtention {
    global Account accountForCreation{get;set;}
    global CreateAccountExtention (ApexPages.StandardController controller){
        accountForCreation=new Account();
    }
    public PageReference createAccount(){
        SendAccountUsingRestApi.createAccount(accountForCreation);
        PageReference similarAccountsPage= new PageReference('/apex/similarAccounts');
        similarAccountsPage.setRedirect(true);
        similarAccountsPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        return similarAccountsPage;
    }
    public PageReference returnPage(){
        PageReference similarAccountsPage= new PageReference('/apex/similarAccounts');
        similarAccountsPage.setRedirect(true);
        similarAccountsPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        return similarAccountsPage;
    }
}
