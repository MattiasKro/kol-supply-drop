import "relay/choice.ash";
import "relay/SupplyDropRelay.ash";

string replaceText = "A label on the radio backpack lists things you can request, except only the first three are legible: rations, fuel, and ordnance.";
string foundText = "Underneath that you scratched: ";

//Choice override for "Request Supply Drop" for Allied Radio Backpack

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
    string newPage = handleSupplyDrop(page_text, replaceText, foundText); 

    newPage.write();	
}
