import "relay/choice.ash";
import "relay/SupplyDropRelay.ash";

//Choice override for "Request Supply Drop" for Allied Radio Backpack

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
    string newPage = handleSupplyDrop(page_text); 

    newPage.write();	
}