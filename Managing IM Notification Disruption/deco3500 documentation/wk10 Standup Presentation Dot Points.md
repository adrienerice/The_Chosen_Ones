What I've Done
- Functional prototype app - little bit more chat functionality development, now need requirements
- Interviews - Main take away- many conlficting requirements
	- **Ephemeral vs Recorded** 
			- "No record of embarassing things I've said" (social context) 
			- vs 
			-  will refer back to answers to my technical questions" (work context)
	- **Read Receipts**
			- "I expect it's on their phone straight away" + "if they haven't 'seen' it they're probably busy"
			- vs
			- "Having read receipts  \[at work\] would be too invasive and increase pressure to respond" "You're being paid" (work context)
		- Delivered Receipts "I know if the message isn't delivered that my wife's phone has run out of battery"
	- **Previews** (combined with read receipts)
		- "It's good to find out the urgency of a message without them getting the read receipt because then they would expect a response"
		- vs
		- "Having to be off-the-cuff is more honest and personal" (social intimacy & immediacy)
- These conflicts are why people use different services for different purposes
	- SnapChat for flirting, WhatsApp/FB messenger etc. for socialising, Slack/Email for work
- How (and should) a design meet these conflicting requirements
	- Combining them doesn't get the benefits of both
		- e.g. choosing read receipts for different people "it would be awkward because people would know if I'd disabled read receipts for them"
- My main issue: overwhelmed with vast number of and conflicting requirements. How can I design something that benefits all human, text-based conversation?
	- There are so many contexts; professional, familial, social, romantic, controlling/abusive. And all these contexts of communication serve a huge array of purposes. 
- I had to return to the inspiration: letting users ask and answer the question: "Is now a good time to talk?"
	- The core of this question: does the sender want a conversation (synchronous) or not?
- I have several ideas for this
	- tabs: email, chat, conversation
		- email: no read receipts, longer form (potentially min. word count)
		- chat: read receipts
		- conversation: shows presence in chat, ephemeral messages
	- reactions (like FB messenger): extending MyButler 
		- sender-controlled notification by reacting to own message (or setting before sent)
		- private, reactive statuses for multiple people
			- managing multiple statuses across groups of people (how likely are users to do this?)
	- Is now a good time? Directly asking
		- Text statuses from MyButler removed 	
			- shrink to communicating only available, semi-busy, busy, or blank
		- Setting own reactive status (not private)
		- Sender controlled notification (none, visual only, audio and visual)
		- Sender controlled previews ([Mother in Law Reads 'Dirty Text' Meant for Husband](https://www.youtube.com/watch?v=VtswhEpT7zY)


What I'm going to do
- Non-functional prototype testing (this weekend)
- Refined requirements (this weekend) 
	- including deeper dive into possible misuse of the technology
- Functional prototype development & testing (next week)
- Poster and promotional materials (next week)

Questions I have
- Best way to test paper prototype?
	- It seems difficult to test the user when their context and the message content is so important?
	- Do I just ask them to imagine that they're in the context, like busy at work? 