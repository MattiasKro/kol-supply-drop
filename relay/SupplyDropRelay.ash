string replaceText = "A label on the radio backpack lists things you can request, except only the first three are legible: rations, fuel, and ordnance.";
string newIntroText = "Some nifty buttons on the radio backpack lists the things you can request.";
string foundText = "Underneath that you scratched: ";

string [int, int] buttonData = {
    {"Skeleton Wars rations", "1 fullness <font color='blueviolet'>EPIC</font> food<br>5 adv", "skelration.gif", "rations"},
    {"Skeleton war fuel can", "1 drunkness <font color='blueviolet'>EPIC</font> drink<br>5-7 adv", "skelgascan.gif", "fuel"},
    {"Skeleton war grenade", "Combat item<br>200-300 damage, a <i>lot</i> more effective against rank-and-file skeletons", "skelgrenade.gif", "ordnance"},
    {"Handheld Allied radio", "Save a supply drop for later.<br>Or sell it for profit.", "radiopackradio.gif", "radio"},
    {"Salary", "15 Chronerz", "chroner.gif", "salary"},
    {"Sniper Support", "Force a non-combat", "bountyrifle.gif", "sniper support"},
    {"Materiel Intel", "10 turns of +100% item drops", "dinseybrain.gif", "materiel intel"},
    {"Ellipsoidtine", "30 turns of +25 Max MP, +50 Max HP, Regen 5-10 MP per Adventure", "circle.gif", "ellipsoidtine"}
};

string trim(string inStr) {
    while (inStr.substring(0, 1) == ' ') {
        inStr = inStr.substring(1, length(inStr));
    }
    while (inStr.substring(length(inStr)-1, length(inStr)) == ' ') {
        inStr = inStr.substring(0, length(inStr)-1);
    }

    return inStr;
}

boolean [string] findUnlockedDrops(string page) {
    boolean [string] available = {
        "rations": true,
        "fuel": true,
        "ordnance": true
    };

    int startPos = page.index_of(foundText);

    if (startPos > 0) {
        int endPos = page.index_of("</p>", startPos + length(foundText));
        string foundCodes = page.substring(startPos + length(foundText), endPos);

        string [int] codes = split_string(foundCodes, ",");
        foreach ix, code in codes {
            available[trim(code)] = true;
        }
    }

    return available;

}

string createDropButton(string title, string description, string icon, string code, boolean [string] available) {
    buffer button;

    string className = (available[code]) ? "" : " hidden";
    button.append('<div data-dropdata="' + code + '" class="drop-button' + className + '" title="' + code + '" id="' + title + '">');
    button.append('<img src="/images/itemimages/' + icon + '" height="30" width="30">');
    button.append('<div class="drop-text">');
    button.append('<strong>' + title + '</strong>');
    button.append('<br>' + description + '</div></div>\n');

    return button;
}

string createButtonPane(boolean [string] available) {
    buffer buttons;
    boolean [string] found;

    buttons.append('<div class="section" style="width:95%">');
    foreach ix in buttonData {
        string [int] btn = buttonData[ix];
        buttons.append(createDropButton(btn[0], btn[1], btn[2], btn[3], available));
        found[btn[3]] = true;
    }
    foreach btn in available {
        if (!found[btn]) {
            buttons.append(createDropButton(btn, "???", "confused.gif", btn, available));
        }
    }
    buttons.append('</div><p>&nbsp;</p>\n');

    buttons.append("<script>\n");
    buttons.append('const buttons = document.querySelectorAll(".drop-button");\n');
    buttons.append('buttons.forEach(button => { button.addEventListener("click", handleDrop, true); });\n');
    buttons.append("</script>\n");

    return buttons;
}

string handleSupplyDrop(string origPage) {
    buffer old;
    buffer newPage;

    old.append(origPage);
    boolean [string] available = findUnlockedDrops(origPage);

    int startPos = old.index_of(replaceText);
    int endPos = old.index_of('<form');
    if (old.contains_text(foundText)) {
        startPos = old.index_of('<p>', startPos);
        newPage = replace(old, startPos, endPos, createButtonPane(available));
    } else {
        newPage = old.insert(endPos, createButtonPane(available));
    }
    newPage = old.replace_string(replaceText, newIntroText);

    newPage.replace_string("</head>", "<script type=\"text/javascript\" src=\"SupplyDrop.js\"></script></head>");
    newPage.replace_string("</head>", '<link rel="stylesheet" type="text/css" href="SupplyDrop.css"></head>');

    return newPage;
}
