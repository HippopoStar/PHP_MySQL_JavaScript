
## Frontend

### jQuery
```
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/4.0.0/jquery.min.js"></script>
```
### Fetch API
[MDN Web Docs - Web > Web APIs > Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)  

### Svelte
```
docker run \
  --rm \
  -it \
  -p 5173:5173 \
  -v ${PWD}/frontend:/home/node/projects \
  -w /home/node/projects \
  node:lts bash
```
```
npx sv create my-app
cd my-app
npm run dev -- --host
```

## Backend

[crates.io - tokio](https://crates.io/crates/tokio)  
[crates.io - actix-web](https://crates.io/crates/actix-web)  
[crates.io - serde](https://crates.io/crates/serde)  

```
docker run \
  --rm \
  -it \
  -p 3000:3000 \
  -v ${PWD}/backend:/root/projects \
  -w /root/projects \
  rust:latest
```
```
cargo new --vcs none --bin my-app
```
