use actix_web::{
    get,
    middleware::Logger,
    post,
    web::{self, Data},
    App, HttpResponse, HttpServer, Responder,
};
use dotenvy_macro::dotenv;
use futures::TryStreamExt;
use log::error;
use models::Climate;
use mongodb::Collection;

mod models;

#[get("/sensor_data")]
async fn get_data(sensor_collection: web::Data<Collection<Climate>>) -> impl Responder {
    let cursor = match sensor_collection.find(None, None).await {
        Ok(cursor) => cursor,
        Err(e) => {
            error!("Error finding documents: {:?}", e);
            return HttpResponse::InternalServerError().finish();
        }
    };

    let x = match cursor.try_collect::<Vec<Climate>>().await {
        Ok(x) => x,
        Err(e) => {
            error!("Error converting cursor to vector: {:?}", e);
            return HttpResponse::InternalServerError().finish();
        }
    };

    HttpResponse::Ok().json(x)
}


#[post("/sensor_data")]
async fn post_data(
    data: web::Json<Climate>,
    sensor_collection: web::Data<Collection<Climate>>,
) -> impl Responder {
    let doc = data.into_inner();
    match sensor_collection.insert_one(doc, None).await {
        Ok(_) => return HttpResponse::Ok().finish(),
        Err(e) => {
            error!("Error inserting document: {:?}", e);
            return HttpResponse::InternalServerError().finish()
        },
    }
}

#[actix_web::main] // or #[tokio::main]
async fn main() -> std::io::Result<()> {
    dotenvy::dotenv().ok();
    env_logger::init();

    let mongodb_client = mongodb::Client::with_uri_str(dotenv!("MONGO_URI"))
        .await
        .unwrap();

    let db = mongodb_client.database("sns");

    let sensor_collection = db.collection::<Climate>("sensor");

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::new(r#""%r" %s %D"#))
            .app_data(Data::new(sensor_collection.clone()))
            .service(web::scope("/api").service(get_data).service(post_data))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
