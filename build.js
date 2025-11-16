const os = require('os');
const fs = require('fs');
const cp = require('child_process');


// Read a text file and normalize its line endings to LF.
function readTextFileSync(pth) {
  var txt = fs.readFileSync(pth, 'utf8');
  return txt.replace(/\r?\n/g, '\n');
}


// Write a text file, converting LF line endings to the OS-specific line endings.
function writeTextFileSync(pth, txt) {
  txt = txt.replace(/\r?\n/g, os.EOL);
  fs.writeFileSync(pth, txt, 'utf8');
}


// Read and parse a JSON file.
function readJSONFileSync(pth) {
  var txt = readTextFileSync(pth);
  return JSON.parse(txt);
}


// Serialize and write a JSON file.
function writeJSONFileSync(pth, obj) {
  var txt = JSON.stringify(obj, null, 2) + '\n';
  writeTextFileSync(pth, txt);
}


// Publish the package to npm for Linux or MacOS.
function publishLinux() {
  var oignore = readTextFileSync('.npmignore'), xignore = oignore;
  xignore += `install.cmd\n`;
  xignore += `vcpkg.exe\n`;
  writeTextFileSync('.npmignore', xignore);
  cp.execSync('npm publish', {stdio: 'inherit'});
  writeTextFileSync('.npmignore', oignore);
}


// Publish the package to npm for Windows.
function publishWin32() {
  var oignore  = readTextFileSync('.npmignore'),   xignore  = oignore;
  var opackage = readTextFileSync('package.json'), xpackage = JSON.parse(opackage);
  xignore += `install.sh\n`;
  xignore += `vcpkg\n`;
  xpackage.name = 'vcpkg.cmd';
  xpackage.main = 'vcpkg.exe';
  xpackage.bin  = {'vcpkg': 'vcpkg.exe'};
  xpackage.scripts.install = 'install.cmd';
  writeTextFileSync('.npmignore', xignore);
  writeJSONFileSync('package.json', xpackage);
  cp.execSync('npm publish', {stdio: 'inherit'});
  writeTextFileSync('.npmignore', oignore);
  writeTextFileSync('package.json', opackage);
}


// Main entry point.
function main() {
  var cmd = process.argv[2];
  switch (cmd) {
    default:
      console.error(`Unknown command: ${cmd}`);
      process.exit(1);
    case 'publish':
      publishLinux();
      publishWin32();
      break;
  }
}
main();
