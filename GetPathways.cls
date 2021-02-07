public with sharing class GetPathways {
    public static void GetPathways(LiveChatTranscript transcript) {
        List<String> pathway = new List<String>();
        String s = String.valueof([SELECT SessionId 
            FROM ConversationDefinitionSessionEngagement 
            WHERE ConversationEngagement.Id = :transcript.Id LIMIT 1].SessionId);
        List<ConversationDefinitionEventLog> dialogs = [SELECT DialogDefinition.MasterLabel
                         FROM ConversationDefinitionEventLog
                         WHERE LogType='StartDialog'
                         AND ParentId = :s
                         ORDER BY EventTimestamp ASC];
        for(ConversationDefinitionEventLog e: dialogs){
            String masterLabel = e.DialogDefinition.MasterLabel;
            pathway.add(masterLabel);
        }
        transcript.dialogPathway__c = String.valueof(pathway);
    }
}

@isTest


trigger GetPathways on LiveChatTranscript (before update) {
    for (LiveChatTranscript transcript: Trigger.new) {
        GetPathways.GetPathways(transcript);
}
