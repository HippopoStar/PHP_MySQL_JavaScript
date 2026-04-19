use actix_web::{App, HttpRequest, HttpServer, web};

async fn index(req: HttpRequest) -> &'static str {
	println!("REQ: {req:?}");
	"Hello world!"
}

#[tokio::main]
async fn main() -> std::io::Result<()> {

	println!("starting HTTP server at http://0.0.0.0:3000");

	HttpServer::new(|| {
		App::new()
			.service(web::resource("/")
				.route(web::get().to(index))
			)
	})
	.bind(("0.0.0.0", 3000))?
	.run()
	.await
}
