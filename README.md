# Image Retrieval API

This document provides instructions on how to use the image retrieval endpoint of our AI-generated image service.

## Endpoint

```
GET https://your-salad-cloud-url/retrieve-image/<filename>
```

Replace your-salad-cloud-url with the actual URL of your Salad Cloud deployment.
Description
This endpoint allows you to download a previously generated image by providing its filename. The filename is returned in the response of the image generation request.
How to Use

## Prerequisites:

You should have already made a successful request to the  ``/generate`` endpoint.
You should have received a response containing an ``image_url`` field.


## Making the Request:

Use the ``image_url`` provided in the generation response, or construct the URL using the filename.
Send a GET request to this URL.


Example Using curl:

```
Copycurl -O -J "https://your-salad-cloud-url/retrieve-image/abc123-456def.png"
```

This will download the image and save it with its original filename.

Example Using Postman:

- Create a new GET request in Postman.
- Enter the URL: ```https://your-salad-cloud-url/retrieve-image/abc123-456def.png```
- Send the request.
- The image will be displayed in the response body. You can save it from there.


## Response

- **Success:** The API will return the image file with a ``200 OK`` status code.
- **Failure:** If the image is not found, you'll receive a ``404 Not Found`` error.

## Notes

- The filename is unique for each generated image.
  
- Images may not be stored indefinitely. It's recommended to retrieve and save important images promptly.
  
- If you're building a frontend application, you can use this URL directly in an ``<img>`` tag's ``src`` attribute.

## Troubleshooting

- If you receive a 404 error, double-check that you're using the correct filename.
  
- Ensure that you're using the correct base URL for your Salad Cloud deployment.
  
- If problems persist, check the logs of your Salad Cloud deployment for any error messages.