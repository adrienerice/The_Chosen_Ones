What I've Done
- There are so many paths to go down and so much more I would like to do but I don't have the time or the access to people. 
- Interviews, main takeaways
	- *__Conflicting requirements: __*
		- Ephemeral vs Recorded (SnapChat vs Slack)
		**Ephemeral** "No record of embarassing things I've said" (social)
		**Recorded** "Refer back to answers to my technical questions" (business)
		- Read Receipts (WhatsApp etc. vs Slack)
		**No Read Receipts** "Having read receipts would be too invasive and put pressure on to respond" "You're being paid" (social pressure)
		**Read Receipts** "I expect it's on their phone straight away" + "If they haven't seen it, they're probably busy"
		**Delivered Receipts**  "I know if the message isn't delivered, my wife's phone is out of battery"
		- Read Receipts combined with: No Previews vs Previews 
		**No Preview** "Having to be off-the-cuff is more honest and more personal" (social intimacy)
		**Preview** "It's good to find out the urgency of the message without read receipts because then they expect a response" (social and practical/organising)  
	
	- Therefore, people use different serivces for different purposes
		- SnapChat for flirting, WhatsApp/FB Messenger etc. for socialising with friends, Slack/Email for work.
	
	- How can a design meet all these requirements? Should a design meet all these requirements?
		- The inspiration for the project was helping users answer the question "Is it okay for me to send a message to them right now?" and as a auxilliary requirement, "I want to tell them that it is or is not a good time to get a message right now"
		- Some message services are clearly used more asynchronously, with larger response times, such as email. Others, such as SnapChat with its disappearing messages and emphasis on the recipient's presence in the chat, are targeted at synchronous conversations. 
		- The confusion arises ("is now a good time") for services that are "in the grey zone"; you have no idea when they might respond and this creates issues of pressures to preview, read and respond
	- The solution is to make it clear which times the message is part of an intention to have a conversation (more synchronous) and which times you are just making a query or don't expect a response. Part of this depends on the awareness you have of their context. 
		- Sender-controlled notifications (MyButler paper, Slack DND "send a notification anyway?") are one way
		- Statuses are one way (In a meeting, Slack) and is enhances by private, reactive statuses (MyButler)
		- Speed of response "If they reply quickly I think they're more available, if they take a while I think they're busy"
	- None of these are very direct. My designs focus on making it more direct. 


I have come up with several design ideas:
- Tabs: Sepearating each form of communication into separate tabs at the bottom of the messenger contacts screen, so users can choose wheter to send a letter (formal, longer form, no read receipts), a chat messge (recorded, previews, read receipts) or have a conversation (ephemeral, no previews, read receipts, shows user presence in chat)
- Reactions: This idea was to extend MyButler in a less cumbersome manner by allowing users to use message reactions (as in FB Messenger) to set a message's notification options (no noise or no noise and no notification). Part of this idea was to include private, reactive statuses as well except allow for multiple statuses with multiple users. However, this would need to include bulk status-setting options (including for groups, e.g. family, friends). As such, I would like to experiment with putting a cap on the number of private statuses that can be set at any one time and see how users react.
- The main idea I have, though, is to make the beginning of the conversation more directly communicated. Users can set their status as "available", "semi-busy" and "busy" (or blank) and when they receive a message, if they are semi-busy or busy the sender will choose whether to notify or not (again, optionally no sound or even no notification). Users can include in their sent message their own status, as in "busy" where they can only make a notification on the recipient's phone if that user is set to "available".
	- The goal is to essentially explicity say in the message "I want to have conversation now" and to give the response back based on recipient status or "I can't have a conversation now"
	- The biggest question I want to answer about this design is the case where a sender says their busy and the recipient gets a notification. I imagine this could be used for shunning by actively bringing to someone's attention that the person who sent them a message is not actually available for a conversation. This may be mitigated by the fact the sender has to actually engage with (view) the conversation to send messages. However, it does show that an actual product should include blocking all notifications from a user as a necessity, regardless of if they think it's an emergency (a "boy who cried wolf" feature). 
- I've also done work on the Chat app (as shown in last standup)

What I'm going to do
- between now and Monday
	- Non-funcional prototype testing
	- Refined requirements
- between Monday and next Friday
	- functional prototype development
- next weekend
	- functional prototype testing
- between now and exhibition
	- Working on poster and promo materials

2. Shorten whole thing (use this as script but leave just dot points for presentation)

		
		
----------------------------
Week  8 Standup
- findings from prototype evals
- refined requirements
- started functional prototype

**Where this work has not been done, identify reasons why**


