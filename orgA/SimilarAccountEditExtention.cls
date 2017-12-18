global class SimilarAccountEditExtention {
    global Account accountForEdit{get;set;}
    global SimilarAccountEditExtention (ApexPages.StandardController controller){
        accountForEdit=new Account();
        accountForEdit.Id=ApexPages.currentPage().getParameters().get('Id');
        System.debug('accountId'+accountForEdit.Id);
        accountForEdit.Name=ApexPages.currentPage().getParameters().get('Name');
        System.debug('accountForEditName'+accountForEdit.Name);
        accountForEdit.Website=ApexPages.currentPage().getParameters().get('Website');
        System.debug('accountWebsite'+accountForEdit.Website);
        accountForEdit.Phone=ApexPages.currentPage().getParameters().get('Phone');
        System.debug('accountPhone'+accountForEdit.Phone);
        accountForEdit.Fax=ApexPages.currentPage().getParameters().get('Fax');
        System.debug('accountFax'+accountForEdit.Fax);
        try{
            accountForEdit.NumberOfEmployees=Integer.valueOf(ApexPages.currentPage().getParameters().get('NumberOfEmployees'));
        }catch(Exception e){
            System.debug('accountNumberOfEmployees'+accountForEdit.NumberOfEmployees);
        }
        accountForEdit.Description=ApexPages.currentPage().getParameters().get('Description');
        System.debug('accountDescription'+accountForEdit.Description);
      System.debug('ApexPages.currentPage().getParameters().get access_token==='+ApexPages.currentPage().getParameters().get('access_token'));   
    }
    public PageReference saveAccount(){
        SendAccountUsingRestApi.callUpdateSimilarAccount(accountForEdit);
        System.debug('Account id To Update is---'+accountForEdit.Id);
        PageReference similarAccountsPage= new PageReference('/apex/similarAccounts');   
        similarAccountsPage.setRedirect(true);
        similarAccountsPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        return similarAccountsPage;
    }
    public PageReference returnPage(){
        PageReference similarAccountsPage = new PageReference('/apex/similarAccounts');            
        similarAccountsPage.setRedirect(true);
        similarAccountsPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        return similarAccountsPage;
    }
}