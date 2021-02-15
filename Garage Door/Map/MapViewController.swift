//
//  MapViewController.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/28/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit
import MapKit

/**
 Map view to view most recent locations of users. App records locations of users who opt in, allowing historical
 travel analysis and eventual heat map generation of most-travelled areas.
 */
class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let center = CLLocation(latitude: Constants.APARTMENT_LATITUDE, longitude: Constants.APARTMENT_LONGITUDE)
        mapView.centerToLocation(center, regionRadius: 10000)
        self.loadAnnotations()
        
        // Add region radius circle overlay
        //self.mapView.addOverlay(MKCircle(center: center.coordinate, radius: Constants.REGION_RADIUS))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Handle user location annotation
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        // Handle custom ImageAnnotations
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }

        let annotation = annotation as! ImageAnnotation
        view?.image = annotation.image
        view?.annotation = annotation
        view?.canShowCallout = true
        view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let url  = URL(string: "http://maps.apple.com/?q=\(view.annotation!.coordinate.latitude),\(view.annotation!.coordinate.longitude)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = .secondaryLabel
        circleRenderer.alpha = 0.05

        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let region = MKCoordinateRegion(
                center: view.annotation!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        
            mapView.setRegion(region, animated: true)
    }
    
    func loadAnnotations() {
        Request.send(url: "https://jlemon.org/rs/\(Auth.TOKEN)/locations") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let locations = try decoder.decode([Location].self, from: result!)
                var pins = [ImageAnnotation]()
                
                for loc in locations {
                    let annotation = ImageAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(loc.Latitude, loc.Longitude)
                    annotation.image = UIImage(named: loc.Name)
                    annotation.title = loc.Name
                    annotation.subtitle = loc.Time
                    pins.append(annotation)
                    DispatchQueue.main.async {
                        // Add accuracy circle overlay around the image
                        self.mapView.addOverlay(MKCircle(center: annotation.coordinate, radius: loc.Accuracy))
                        
                        self.mapView.addAnnotation(annotation)
                    }
                }
                
                // Zoom map to fit all annotations
                DispatchQueue.main.async {
                    self.mapView.showAnnotations(pins, animated: false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
