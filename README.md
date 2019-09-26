# ldFile

file loader helper in vanilla JS.

## Usage

    var ldf = new ldFile(config);
    ldf.on("change", function(ret) {
      for(i=0;i<ret.length;i++) {
        console.log(
          ret[i].result,    # file content
          ret[i].file       # file object
        );
      }
    });


## Configuration

 * root - HTMLElement or CSS Selector for the input element.
 * type - one of <[dataurl text binary arraybuffer blob bloburl]>. default binary.
 * ldcv - ldCover for choosing encoding for text type. fallback to browser prompt if omitted.


## Method
 * on - add event listener. Currently only one event fired:
   * load - fired when input value changed. provide a list of file information as param, with following format for each object:
     - file: the file object provided by browser.
     - result: file content parsed by ldFile.

## API

 * ldFile.fromURL(url, type, encoding) - load file by URL.
   - type is the same as the type in ldFile object configuration.
   - encoding is default utf-8 and only applicable when type is text.
   - return a promise
   - resolve a {result, file} object.
 * ldFile.fromFile(file, type, encoding) - load File object
   - same with ldFile.fromURL except that the first param (file) is a File object.

## Compatibility

ldFile uses following HTML5 features, which may not be supported by all browsers:

 * File Reader ( IE <= 9; read as binary needs polyfill for IE <= 11 )
 * Promise  ( IE <= 11, some mobile browsers )

Please use Polyfills to support legacy browsers if necessary.


## License

MIT
