import LLM "mo:llm";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

persistent actor MangroveConservationAI {
  // Store some basic knowledge about mangrove restoration
  private let mangroveKnowledge : [Text] = [
    "Mangroves are salt-tolerant trees that create vital ecosystems in coastal areas.",
    "Mangrove forests protect coastlines from erosion and storm damage.",
    "Blue economy refers to sustainable use of ocean resources for economic growth and ecosystem health.",
    "Mangrove restoration is a key component of blue carbon initiatives.",
    // Add more knowledge entries as needed
  ];

  // Function to enhance prompts with mangrove knowledge
  private func enhancePrompt(userPrompt : Text) : Text {
    "As an AI focused on mangrove restoration and blue economy, consider this information: " # 
    Text.join(". ", mangroveKnowledge.vals()) # 
    ". Now address this query: " # userPrompt;
  };

  // Enhanced prompt function with mangrove knowledge
  public func prompt(userPrompt : Text) : async Text {
    let enhancedPrompt = enhancePrompt(userPrompt);
    await LLM.prompt(#Llama3_1_8B, enhancedPrompt);
  };

  // Enhanced chat function with mangrove knowledge context
  public func chat(messages : [LLM.ChatMessage]) : async Text {
    // Add context message if it's a new conversation
    let enhancedMessages = if (messages.size() == 1) {
      // If this is the first message, add context
      let contextMessage : LLM.ChatMessage = {
        role = #system_;
        content = "You are a specialized AI assistant focused on mangrove restoration and blue economy initiatives. Provide information about mangrove conservation, coastal ecosystem management, and sustainable blue economy practices.";
      };
      Array.append([contextMessage], messages);
    } else {
      messages;
    };
    
    await LLM.chat(#Llama3_1_8B, enhancedMessages);
  };
};