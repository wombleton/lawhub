var jsdiff = require('../index')

var result = jsdiff.diff('a', 'b');

result = jsdiff.diff('a\nb\nc\nda\nb\nc\nda\nb\nc\nd', 'a\nb\nc\nda\nb\nc\nd\nb\nc\nd', { context: 1 });

result = jsdiff.diff('1\n 2\n x\n 4\n 5\n 6\n \n 7\n 8\n 9\n 0\n a\n b\n y\n d\n e\n f\n g\n h\n i\n j\n k\n l\n m\n n\n o\n p', '1\n 2\n 3\n 4\n 5\n 6\n \n 7\n 8\n 9\n 0\n a\n b\n c\n d\n e\n f\n g\n h\n i\n j\n k\n l\n m\n n\n o\n p', { context: 1 });
console.log(result);
