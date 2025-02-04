/**
 * @File Name          : <ClassName>.cls
 * @Description        : Visualisation with VS Code
 * @Author             :  AMO <Spoon Consulting>
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10-20-2022
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    DD-MMM-YYYY, HH:MM:SS      <TRIGRAM>      Initial Version
**/
public with sharing class AP01_UpdateAccount {
    /**
         * @description Method to display Hello World.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Display Hello World.
         **/
    public static void helloWorld(){
        System.debug('Hello World');
    }
    /**
         * @description Method to insert in account.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Insert Account details.
         **/
    public static void insertAccount(){
        Account acct = new Account();
        acct.Name = 'Toto Polo';
        acct.BillingStreet = 'Royal Rd';
        acct.BillingCity = 'Moka';
        acct.BillingCountry = 'Mauritius';
        acct.Phone = '985632145';
        acct.Region__c = 'East';
        Insert acct;

    }
     /**
         * @description Method to update phone in account.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Update Phone details.
         **/
   public static void updatePhone(){
        Account acc = new Account();
        acc.Id = '0014H00004CTltnQAD';
        acc.Phone = '4332153';
        Update acc;

   }
   /**
         * @description Method to delete account.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Delete.
         **/
    public static void deleteAccount(){
        Account acc = new Account();
        acc.Id = '0014H00004CTltnQAD';
        Delete acc;

   }
   /**
         * @description Method to return the account name where the region is north.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return return the account name
         **/
   public static void accountNameWhereRegionIsNorth(){

        List<Account> lstAcc = [SELECT Id, Region__c, Name FROM Account WHERE Region__C = 'North'];
        for(Account acc: lstAcc){
            
            System.debug(acc.Name);

        }
    }   
    /**
         * @description Insert 10 accounts (RecordType: Individual and all the required fields need to be 
         * filled) and for each account, insert a contact (Address and phone must contain the same
         *  corresponding data as the account).
                Note: RecordTypeId must not be hardcoded
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Insert 10 account and insert contact
         **/
    public static void insertTenAccount(){
            List<Account> lstAccToInsert = New List<Account>();
            List<Contact> lstCon = New List<Contact>();
            String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
            for(Integer i=0; i<10; i++){
                Account acc = new Account();
                acc.RecordTypeId = recordTypeId;
                acc.Name = 'scfdsscsdv'+ (i+1);
                acc.BillingStreet = 'Royal Rd' + (i+1);
                acc.BillingCity = 'Moka';
                acc.BillingCountry = 'Mauritius';
                acc.Phone = '985632145';
                acc.Region__c = 'East';
                lstAccToInsert.add(acc);
            } 

            if(lstAccToInsert.size()> 0 ){
                Insert lstAccToInsert;
            }

            for(Account acc: lstAccToInsert){
                Contact con = new Contact(
                    AccountId = acc.Id,
                    LastName = acc.Name,
                    OtherStreet = acc.BillingStreet,
                    OtherCity = acc.BillingCity,
                    OtherCountry = acc.BillingCountry,
                    Phone = acc.Phone
                );
                lstCon.add(con);
            }

            if(lstAccToInsert.size()> 0 ){
                Insert lstCon;
            }       
            
    }
    /**
         * @description Method that takes as input a string(color) and query all vehicles whose color
         * match the color passed as parameter to the method. Fields to include in the query :Make, Model
         * ,Mileage.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Make, Model, Mileage of vehicle .
         **/
    public static void vehiclesColorMatch(String Color){        
        List<Vehicle__c> lstVeh = [SELECT Make__c,Mileage__c,Model__c FROM Vehicle__c WHERE Colour__c =: Color];
        for(Vehicle__c veh: lstVeh){        
            System.debug('Vehicles' + veh);    
       }       
    }
    /**
         * @description define as set with 2 colors and query all vehicle matching those color.
         * Fields to include in the query :Make, Model
         * ,Mileage.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Make, Model, Mileage of vehicle .
         **/
    public static void setVehiclesColorMatch(){
        Set<String> setColor = new Set<String>{'Black','Blue'};
            List<Vehicle__c> lstVeh = [SELECT Make__c,Mileage__c,Model__c FROM Vehicle__c WHERE Colour__c IN: setColor];
            for(Vehicle__c veh: lstVeh){        
                System.debug('Vehicles' + veh);    
        }
    }
     /**
         * @description map Reg Num Make On Vehicle
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Registration number and make of vehicle .
         **/
    public static void mapRegNumMakeOnVehicle(){
        Map<String,String> mapRegNumMake = new Map<String,String>();

        //add Items
        mapRegNumMake.put('12 JN 94', 'Toyato Glanza');
        mapRegNumMake.put('78 OC 98', 'Toyato supra');
        mapRegNumMake.put('1 JN 22', 'BMW X6 M');
        mapRegNumMake.put('678 DC 00', 'Honda Civic EK3');

        //print the value 
        System.debug('My Cars and their make: mapRegNumMake' + mapRegNumMake);

        //print map size
        System.debug('Map size: MapRegNumMake: ' + mapRegNumMake.size());

    }
    /**
         * @description map of clothes colour and list of nice and happy employee names.
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return clothes color of employee
         **/
    public static void mapClothesColourEmployee(){
            Map<String,List<String>> mapColorEmployee = new Map<String,List<String>>();
           
          
            mapColorEmployee.put('Black', new List<String>{'Tom','Mila'});
            mapColorEmployee.put('Blue', new List<String>{'John'});

            //print the value 
            System.debug('Clothes color and Employee name: ' + mapColorEmployee);

            //print map size
            System.debug('Map size:  ' +mapColorEmployee.size());
            
            //get element
            if(mapColorEmployee.containsKey('Black')){
                System.debug('Happy employee wearing black color: ' + mapColorEmployee.get('Black'));
            }
            if(mapColorEmployee.containsKey('Blue')){
                System.debug('Happy employee wearing blue color: ' + mapColorEmployee.get('Blue'));
            }   
            
            //print all different colors
            System.debug('Different colors' + mapColorEmployee.keySet());

            //print all employee names
            System.debug('All Super happy employees names: ' + mapColorEmployee.values());

            Integer numOfEmployee = 0;
            for (String color : mapColorEmployee.keySet()) {
                // returns list of extremely happy employees wearing color x
                numOfEmployee += mapColorEmployee.get(color).size();
                
            }
            System.debug('Number of extremely happy employess: ' + numOfEmployee);
        
           
    }
    /**
         * @description Create a map to store country as Key and corresponding states as Values.
         *United States -> Connecticut , Nebraska, New Jersey
         * Germany -> Berlin, Hamburg
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return Country and their state
         **/
    public static void mapCountry(){
        Map<String,List<String>> mapCountry = new Map<String,List<String>>();           
          
        mapCountry.put('United States', new List<String>{'Connecticut' , 'Nebraska', 'New Jersey'});
        mapCountry.put('Germany ', new List<String>{ 'Berlin', 'Hamburg'});

        //print the key and value 
        System.debug('Country and their state: ' + mapCountry);

        //print map size
        System.debug('Map size:  ' + mapCountry.size());
    }
    
    /**
         * @description query all account where region is not null.
         * build a map of region and list of accounts output map
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return account where region is not null
        **/  
    public static void mapRegionOnAccount(){
        Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
        List<Account> lstacc = [SELECT Region__c,Name, Id FROM Account WHERE Region__c != Null];
        for (Account acc : lstacc) {
            if(acc.Region__c == 'East'){
                if(mapAccount.containsKey('East')){
                    mapAccount.get('East').add(acc);
                }
                else{
                    mapAccount.put('East', new List<Account>{acc});
                }                
            }
            else if(acc.Region__c == 'North'){
                if(mapAccount.containsKey('North')){
                    mapAccount.get('North').add(acc);
                }
                else{
                    mapAccount.put('North', new List<Account>{acc});
                }
              
            }
            else if(acc.Region__c == 'West'){
                if(mapAccount.containsKey('West')){
                    mapAccount.get('West').add(acc);
                }
                else{
                    mapAccount.put('West', new List<Account>{acc});
                }
                
            }
            else if(acc.Region__c == 'South'){
                if(mapAccount.containsKey('South')){
                    mapAccount.get('South').add(acc);
                }
                else{
                    mapAccount.put('South', new List<Account>{acc});  
                }
                             
            }
        }
        System.debug('Map Account: ' + mapAccount);
    }
    /**
         * @description query all account where region is not null.
         * build a map of region and list of accounts output map
         * @author Aaliyah Mohungoo | 19/10/2022
         * @return account where region is not null, add to map
        **/  
    public static void mapRegionOnAccountOptimized(){
        System.debug('START' );
        Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
        List<Account> lstacc = [SELECT Region__c,Name, Id FROM Account WHERE Region__c != Null];
        System.debug('List lstacc ' + lstacc.size());
            for (Account acc : lstacc) {            
                
                if(mapAccount.containsKey(acc.Region__c)){
                    mapAccount.get(acc.Region__c).add(acc);
                }
                else{
                    mapAccount.put(acc.Region__c, new List<Account>{acc});
                }            
                
            }
            System.debug('Map Account: ' + mapAccount);
    }
}