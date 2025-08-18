
import XCTest
@testable import Andrea   // 👈 asegúrate de que coincide con el nombre de tu app

final class EnumTemasTests: XCTestCase {

    func testDayNight_returnsLightDuringDay() throws {
        // Simulamos las 10 de la mañana
        var components = DateComponents()
        components.hour = 10
        let date = Calendar.current.date(from: components)!

        let tema = EnumTemas.dayNight.resolved(for: .light, date: date)
        XCTAssertEqual(tema, .light, "A las 10 de la mañana debería devolver .light")
    }

    func testDayNight_returnsDarkDuringNight() throws {
        // Simulamos las 22 de la noche
        var components = DateComponents()
        components.hour = 22
        let date = Calendar.current.date(from: components)!

        let tema = EnumTemas.dayNight.resolved(for: .light, date: date)
        XCTAssertEqual(tema, .dark, "A las 22 debería devolver .dark")
    }
}
