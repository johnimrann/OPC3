public class TestDataFactory {
    public static Account createTestAccount() {
        Account acc = new Account(
            Name = 'Test Account ' + DateTime.now().getTime()
        );
        insert acc;
        return acc;
    }
    
    public static List<Case> createTestCases(Id accountId, Integer numCases) {
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < numCases; i++) {
            cases.add(new Case(
                AccountId = accountId,
                Subject = 'Test Case ' + i,
                Status = 'New',
                Priority = 'Medium'
            ));
        }
        insert cases;
        return cases;
    }
    
    public static List<Opportunity> createTestOpportunities(Id accountId, Integer numOpps) {
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++) {
            opps.add(new Opportunity(
                AccountId = accountId,
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 1000.00 * (i + 1)
            ));
        }
        insert opps;
        return opps;
    }
}