const http = require('http');

const TARGET_HOST = '192.168.101.10';
const TARGET_PORT = 8912;
const LISTEN_PORT = 8912;
const LISTEN_HOST = '127.0.0.1';

http.createServer((req, res) => {
  const options = {
    hostname: TARGET_HOST,
    port: TARGET_PORT,
    path: req.url,
    method: req.method,
    headers: req.headers,
  };

  const proxy = http.request(options, (r) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.writeHead(r.statusCode, r.headers);
    r.pipe(res);
  });

  proxy.on('error', (e) => {
    console.error('Proxy error:', e.message);
    res.writeHead(502);
    res.end(e.message);
  });

  req.pipe(proxy);
}).listen(LISTEN_PORT, LISTEN_HOST, () => {
  console.log(`NCM proxy: ${LISTEN_HOST}:${LISTEN_PORT} -> ${TARGET_HOST}:${TARGET_PORT}`);
});
