(function () {
    function copyTextToClipboard(text) {
        var textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.left = '-1';
        textArea.style.top = '-1';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
    }
    var codeBlockElements = document.getElementsByClassName('copyable');
    for (var i = 0; i < codeBlockElements.length; i++) {
        var block = codeBlockElements[i];
        var copyIcon = new Image(16, 16);
        copyIcon.setAttribute('src', './assets/copy-icon.svg');
        copyIcon.setAttribute('alt', 'copy');
        copyIcon.setAttribute('title', 'copy to clipboard');
        block.insertBefore(copyIcon, block.children[0]);
        copyIcon.addEventListener('click', function(block) {
            var text = block.getElementsByTagName('pre')[0].innerText;
            copyTextToClipboard(text);
        }.bind(null, block));
    }
})();
