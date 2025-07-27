
function handleDrop(event) {
    event.stopPropagation();
    const source = event.target || event.srcElement;
    callForSupplies(source);
}

function callForSupplies(source) {
    if (source.dataset.dropdata != null) {
        console.log("Click! " + source.dataset.dropdata);
        document.getElementsByName('request')[0].value = source.dataset.dropdata;
        document.getElementsByName('request')[0].form.submit();
    } else {
        if (source.parentNode != null) {
            callForSupplies(source.parentNode);
        }
        return false;
    }
}
