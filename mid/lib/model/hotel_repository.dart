import 'hotel.dart';

class HotelRepository {
  static List<Hotel> createHotelList() {
    return [
      Hotel(
          id: 1,
          name: 'The Cozy Stay',
          location: 'Pohang, Yeongildae Beach',
          phoneNum: '054-111-2222',
          desription:
              'A comfortable 3-star hotel near the beautiful Yeongildae Beach. Free Wi-Fi and breakfast included.',
          stars: 3,
          img: 'assets/hotel/hotel6.jpeg'),
      Hotel(
          id: 2,
          name: 'Sunset Grand Hotel',
          location: 'Busan, Haeundae',
          phoneNum: '051-333-4444',
          desription:
              'Enjoy stunning sunset views at our luxurious 5-star hotel in Haeundae. Features a rooftop pool and spa.',
          stars: 5,
          img: 'assets/hotel/hotel5.jpeg'),
      Hotel(
          id: 3,
          name: 'Green Valley Inn',
          location: 'Jeju, Andeok-myeon',
          phoneNum: '064-555-6666',
          desription:
              'A peaceful 2-star inn nestled in the green valley of Jeju. Perfect for nature lovers.',
          stars: 2,
          img: 'assets/hotel/hotel4.jpeg'),
      Hotel(
          id: 4,
          name: 'City Center Plaza Hotel',
          location: 'Seoul, Myeongdong',
          phoneNum: '02-777-8888',
          desription:
              'Conveniently located 4-star hotel in the heart of Myeongdong. Easy access to shopping and dining.',
          stars: 4,
          img: 'assets/hotel/hotel3.jpeg'),
      Hotel(
          id: 5,
          name: 'Historical Gyeongju House',
          location: 'Gyeongju, Hwangnidan-gil',
          phoneNum: '054-999-0000',
          desription:
              'Experience traditional Korean hospitality at our charming guesthouse in the historic Hwangnidan-gil area.',
          stars: 3,
          img: 'assets/hotel/hotel2.jpeg'),
      Hotel(
          id: 6,
          name: 'Mountain Breeze Resort',
          location: 'Sokcho, Seoraksan Park',
          phoneNum: '033-222-1111',
          desription:
              'Relax and rejuvenate at our 4-star resort surrounded by the beautiful Seoraksan mountains.',
          stars: 4,
          img: 'assets/hotel/hotel1.jpeg'),
    ];
  }
}
