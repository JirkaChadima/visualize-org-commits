const fetch = require('node-fetch');
const parseLinkHeader = require('parse-link-header');

function fetchRepos (url) {
  return fetch(url)
    .then((r) => {
      if (r.headers.get('link')) {
        const links = parseLinkHeader(r.headers.get('link'));
        if (links.next) {
          return fetchRepos(links.next.url)
            .then(async (s) => {
              return s.concat(await r.json());
            });
        }
      }
      return r.json();
    });
}

async function main () {
  let repoList = await fetchRepos(`https://api.github.com/orgs/${process.env.ORGANIZATION}/repos?type=public`);
  if (repoList.message) {
    console.error(repoList.message);
    process.exit(1);
  }
  repoList.map((r) => {
    console.log(r.name);
  });
}
main();
