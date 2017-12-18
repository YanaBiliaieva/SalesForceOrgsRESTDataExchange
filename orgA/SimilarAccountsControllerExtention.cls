global with sharing class SimilarAccountsControllerExtention {
    global  List <Account> similarAccountsList{get;set;}
    global Id accountToEditId{get;set;}
    global String accountToDeleteId{get;set;}
    global String accountName{get;set;}
    global Id selectedAccountId{set;get;}
    public String acctId {get; set;}
    
    global SimilarAccountsControllerExtention(ApexPages.StandardController controller){
        acctId=ApexPages.currentPage().getParameters().get('id');
        if(acctId==null){
            acctId=ApexPages.currentPage().getParameters().get('currentAccountId');
            getContent(acctId);
        }else{
            getContent(acctId);
        }        
    } 
    public List<Account> getContent(String acctId){     
       List<Account> accountPageName = [SELECT Name FROM Account WHERE Id = :acctId LIMIT 1];
        if(!accountPageName.isEmpty()){
            accountName=accountPageName[0].Name;
            accountName=accountName.replace(' ', '+');
            System.debug('Replaced name: '+accountName);
        }
        similarAccountsList=SendAccountUsingRestApi.similarAccounts(accountName);    
        return similarAccountsList;
    }   
    public PageReference editSimilarAccount(){
        selectedAccountId = Apexpages.currentPage().getParameters().get('accountToEditId');
        List <String> fieldsNames= new List <String>{'Id','Name','Website', 'Phone', 'Fax', 'NumberOfEmployees', 'Description'};
		PageReference accountEditPage= new PageReference('/apex/accountEditPage');
        accountEditPage.setRedirect(false);
        if(selectedAccountId!=null){
			String strName;
            for(Integer j=0;j<similarAccountsList.size();j++){
                System.debug('IN editSimilarAccount=====(String)similarAccountsList[j].Id===='+(String)similarAccountsList[j].Id);
                System.debug('IN editSimilarAccount=====selectedAccountId===='+selectedAccountId);
                if(((String)similarAccountsList[j].Id).contains(selectedAccountId)){
                    for(Integer k=0;k<fieldsNames.size();k++){
                        if(fieldsNames[k]=='NumberOfEmployees'){
                            String strValue=String.valueOf(similarAccountsList[j].NumberOfEmployees);
                            accountEditPage.getParameters().put('NumberOfEmployees', strValue);
                            System.debug('NumberOfEmployees'+strValue);
                        }
                        strName=fieldsNames[k];
                        String strValue=String.valueOf(similarAccountsList[j].get(strName));
                        accountEditPage.getParameters().put(strName, strValue);
                        System.debug(strName+strValue);
                    }    
                }   
            }
        }      
        System.debug('--------selectedAccountId is---'+selectedAccountId);
        if(ApexPages.currentPage().getParameters().get('id')==null){
            accountEditPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        }else{
            accountEditPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('id')); 
        } 
        return accountEditPage;
       }
    public void deleteSimilarAccount(){
            Id accountToDelete= Apexpages.currentPage().getParameters().get('accountToDeleteId');
        	System.debug('account id To Delete is---'+accountToDelete);
            SendAccountUsingRestApi.deleteSimilarAccount(accountToDelete);
        	getContent(acctId); 
    }
    public PageReference createAccount(){
        PageReference createAccountPage= new PageReference('/apex/createAccount');
        if(ApexPages.currentPage().getParameters().get('id')==null){
            createAccountPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('currentAccountId'));
        }else{
            createAccountPage.getParameters().put('currentAccountId', ApexPages.currentPage().getParameters().get('id')); 
        } 
        createAccountPage.setRedirect(true);
        return createAccountPage;
    }
}