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
      description: "Explorez des milliers d'opportunités qui correspondent à vos compétences et aspirations. Trouvez l'emploi idéal en quelques clics !"
  ),
  OnbordingContent(
      title: 'Parcourez la liste des emplois',
      image: 'assets/images/onboard2.svg',
      description: "Accédez à une vaste sélection d'offres d'emploi. Filtrez, triez et découvrez les opportunités qui vous conviennent le mieux."
  ),
  OnbordingContent(
      title: 'Postulez aux meilleurs emplois',
      image: 'assets/images/onboard3.svg',
      description: "Avec notre interface intuitive, postulez facilement aux offres qui vous intéressent et suivez l’avancement de vos candidatures."
  ),
  OnbordingContent(
      title: 'Faites votre carrière',
      image: 'assets/images/onboard4.svg',
      description: "Progressez dans votre carrière avec des opportunités qui favorisent votre épanouissement professionnel et votre croissance."
  ),
  OnbordingContent(
      title: 'Nos conseils sont à votre disposition',
      image: 'assets/images/onboard5.svg',
      description: "Bénéficiez de recommandations personnalisées et de conseils d’experts pour réussir chaque étape de votre parcours."
  ),
];