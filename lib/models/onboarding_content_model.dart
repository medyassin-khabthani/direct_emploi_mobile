class OnbordingContent {
  String image;
  String title;
  String description;

  OnbordingContent({required this.image, required this.title, required this.description});
}

List<OnbordingContent> contents = [
  OnbordingContent(
      title: 'Recherchez votre emploi',
      image: 'assets/images/onboard1.svg',
      description: "Lorem ipsum dolor sit amet consectetur. Turpis facilisi tempus amet massa amet gravida cras nec."
  ),
  OnbordingContent(
      title: 'parcourir la liste des emplois',
      image: 'assets/images/onboard2.svg',
      description: "Lorem ipsum dolor sit amet consectetur. Turpis facilisi tempus amet massa amet gravida cras nec."
  ),
  OnbordingContent(
      title: 'Postuler aux meilleurs emplois',
      image: 'assets/images/onboard3.svg',
      description: "Lorem ipsum dolor sit amet consectetur. Turpis facilisi tempus amet massa amet gravida cras nec."
  ),
  OnbordingContent(
      title: 'Faites votre carrière',
      image: 'assets/images/onboard4.svg',
      description: "Lorem ipsum dolor sit amet consectetur. Turpis facilisi tempus amet massa amet gravida cras nec."
  ),
  OnbordingContent(
      title: 'Nos conseils sont à votre disposition',
      image: 'assets/images/onboard5.svg',
      description: "Lorem ipsum dolor sit amet consectetur. Turpis facilisi tempus amet massa amet gravida cras nec."
  ),
];