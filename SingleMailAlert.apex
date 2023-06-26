public class SingleMailAlert implements Database.Batchable<sObject> 
{
    public Database.QueryLocator start(Database.BatchableContext BC){
        Id recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        System.debug('Record Id:'+recordTypeId);
        /*
        String query ='select Id,OwnerId,Owner.Name,Owner.Email,Owner.MobilePhone,Primary_Customer_Email__c from Account where ';
        query = query+' OwnerId!=null AND RecordTypeId =:'+recordTypeId;
        query = query+' OwnerId!=null AND RecordTypeId =:'+recordTypeId;
        */	
        String mail1='imran.shaik@bvclogistics.com';
        String mail2='';
        String query ='select Id,OwnerId,Owner.Name,Owner.Email,Owner.MobilePhone,Primary_Customer_Email__c from Account where ';
        query = query+' OwnerId!=null AND RecordTypeId =:'+recordTypeId+' Name =:'+mail1;        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> CustomerList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();        
        for(Account ac : CustomerList)
        {                    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toadd = new List<String>();
            toadd.add(ac.Primary_Customer_Email__c);
            mail.SetToAddresses(toadd);
            mail.SetReplyTo('care@bvclogistics.com');
            string body = 'Dear Team <br/>'+
                'We have new leaders at BVC who will facilitate a great shipping experience for you.'+
                '<br/>The changes include the international business CEO Yogesh Bansode, domestic business CBO & CEO, Harsh Arora and Rajesh Neelakanta who aren’t a part of BVC any longer.<br/>'+
                'The new leaders are:<br/>'+
                'Krishnanand Bastikar - CBO (+918652633549)<br/>'+
                'Vipin Tokas - COO<br/>'+
                'Pratik Sanghani - VP Sales (+918652633595)<br/>'+
                'Both Krishna and Pratik have been at BVC for over a decade, while Vipin comes with deep experience of having built 4 unicorns over the past 15 years.<br/>'+
                'Your primary point of contact is:<br/>'+
                ' '+ac.Owner.Name+'<br/>'+
                ' '+ac.Owner.MobilePhone+'<br/>'+
                ' '+ac.Owner.Email+'<br/>'+
                'In case of any escalation, you could reach out to:<br/>'+
                '<reportingManagerName>		<br/>'+
                '<reportingManagerNumber><br/>'+
                '<ReportingManagerEmailID><br/>'+
                'The leadership of BVC is always available with Group CEO - Bhavik Chinai available on bhavik.chinai@bvcventures.com for any unresolved escalation.<br/>';            
            mail.setSubject('BVC One Point Contact Change'); 
            mail.setSaveAsActivity(false); 
            mail.setHtmlBody(body); 
            mails.add(mail);
        }                
        Messaging.sendEmail(mails);
    }
    
    public void finish(Database.BatchableContext BC){
    }
}
