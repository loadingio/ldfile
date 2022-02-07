# ldfile

file loader helper in vanilla JS.


## Usage

install vis npm:

    npm install --save ldfile


include required js file:

    <script src="path-to-ldfile/index.js"></script>


then:

    var ldf = new ldfile(config);
    ldf.on("load", function(ret) {
      for(i=0;i<ret.length;i++) {
        console.log(
          ret[i].result,    # file content
          ret[i].file       # file object
        );
      }
    });


## Constructor Options

 * `root`: HTMLElement or CSS Selector for the input element.
 * `type`: one of <[dataurl text binary arraybuffer blob bloburl]>. default binary.
 * `ldcv`: ldcover for choosing encoding for text type. fallback to browser prompt if omitted.


## API

 * `on`: add event listener. Possible events:
   - `load`: fired when input value changed, along with a list of objects with following members:
     - `file`: the file object provided by browser.
     - `result`: file content parsed by ldfile.


## ldfile / Static Methods

 * `fromURL(url, type, encoding)` - load file by URL. return promise resolving to {result, file} object.
   - params:
     - `type`: the same as the type in ldfile object configuration.
     - `encoding`: default utf-8 and only applicable when type is text.
   - returns:
     - `result`: parsed content based on given `type`.
     - `file`: corresponding file object
 * `fromFile(file, type, encoding)` - load File object
   - same with `fromURL` except that the first param (file) is a File object.
 * `download(opt)` - download file based on `opt`, which contains:
   - `href`: url for the file to download. either `href` or `blob` should be given.
   - `blob`: file to download. ignored if `href` is provided
   - `mime`: file format. ( e.g., "application/pdf" )
   - `name`: saved filename 


## Compatibility

ldfile uses following HTML5 features, which may not be supported by all browsers:

 * File Reader ( IE <= 9; read as binary needs polyfill for IE <= 11 )
 * Promise  ( IE <= 11, some mobile browsers )

Please use Polyfills to support legacy browsers if necessary.


## License

MIT
