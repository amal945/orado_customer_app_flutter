class AppStrings {
  static RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );

  static RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$');

  static String profPic = 'assets/images/placeholder.jpg';
  static String inrSymbol = '₹';

  static Map<String, List<Map<String, String>>> countryCodes = <String, List<Map<String, String>>>{
    'countries': <Map<String, String>>[
      <String, String>{'name': 'Afghanistan', 'code': '+93'},
      <String, String>{'name': 'Albania', 'code': '+355'},
      <String, String>{'name': 'Algeria', 'code': '+213'},
      <String, String>{'name': 'Andorra', 'code': '+376'},
      <String, String>{'name': 'Angola', 'code': '+244'},
      <String, String>{'name': 'Antigua and Barbuda', 'code': '+1-268'},
      <String, String>{'name': 'Argentina', 'code': '+54'},
      <String, String>{'name': 'Armenia', 'code': '+374'},
      <String, String>{'name': 'Australia', 'code': '+61'},
      <String, String>{'name': 'Austria', 'code': '+43'},
      <String, String>{'name': 'Azerbaijan', 'code': '+994'},
      <String, String>{'name': 'Bahamas', 'code': '+1-242'},
      <String, String>{'name': 'Bahrain', 'code': '+973'},
      <String, String>{'name': 'Bangladesh', 'code': '+880'},
      <String, String>{'name': 'Barbados', 'code': '+1-246'},
      <String, String>{'name': 'Belarus', 'code': '+375'},
      <String, String>{'name': 'Belgium', 'code': '+32'},
      <String, String>{'name': 'Belize', 'code': '+501'},
      <String, String>{'name': 'Benin', 'code': '+229'},
      <String, String>{'name': 'Bhutan', 'code': '+975'},
      <String, String>{'name': 'Bolivia', 'code': '+591'},
      <String, String>{'name': 'Bosnia and Herzegovina', 'code': '+387'},
      <String, String>{'name': 'Botswana', 'code': '+267'},
      <String, String>{'name': 'Brazil', 'code': '+55'},
      <String, String>{'name': 'Brunei', 'code': '+673'},
      <String, String>{'name': 'Bulgaria', 'code': '+359'},
      <String, String>{'name': 'Burkina Faso', 'code': '+226'},
      <String, String>{'name': 'Burundi', 'code': '+257'},
      <String, String>{'name': 'Cabo Verde', 'code': '+238'},
      <String, String>{'name': 'Cambodia', 'code': '+855'},
      <String, String>{'name': 'Cameroon', 'code': '+237'},
      <String, String>{'name': 'Canada', 'code': '+1'},
      <String, String>{'name': 'Central African Republic', 'code': '+236'},
      <String, String>{'name': 'Chad', 'code': '+235'},
      <String, String>{'name': 'Chile', 'code': '+56'},
      <String, String>{'name': 'China', 'code': '+86'},
      <String, String>{'name': 'Colombia', 'code': '+57'},
      <String, String>{'name': 'Comoros', 'code': '+269'},
      <String, String>{'name': 'Congo, Democratic Republic of the', 'code': '+243'},
      <String, String>{'name': 'Congo, Republic of the', 'code': '+242'},
      <String, String>{'name': 'Costa Rica', 'code': '+506'},
      <String, String>{'name': "Cote d'Ivoire", 'code': '+225'},
      <String, String>{'name': 'Croatia', 'code': '+385'},
      <String, String>{'name': 'Cuba', 'code': '+53'},
      <String, String>{'name': 'Cyprus', 'code': '+357'},
      <String, String>{'name': 'Czech Republic', 'code': '+420'},
      <String, String>{'name': 'Denmark', 'code': '+45'},
      <String, String>{'name': 'Djibouti', 'code': '+253'},
      <String, String>{'name': 'Dominica', 'code': '+1-767'},
      <String, String>{'name': 'Dominican Republic', 'code': '+1-809, +1-829, +1-849'},
      <String, String>{'name': 'East Timor (Timor-Leste)', 'code': '+670'},
      <String, String>{'name': 'Ecuador', 'code': '+593'},
      <String, String>{'name': 'Egypt', 'code': '+20'},
      <String, String>{'name': 'El Salvador', 'code': '+503'},
      <String, String>{'name': 'Equatorial Guinea', 'code': '+240'},
      <String, String>{'name': 'Eritrea', 'code': '+291'},
      <String, String>{'name': 'Estonia', 'code': '+372'},
      <String, String>{'name': 'Eswatini', 'code': '+268'},
      <String, String>{'name': 'Ethiopia', 'code': '+251'},
      <String, String>{'name': 'Fiji', 'code': '+679'},
      <String, String>{'name': 'Finland', 'code': '+358'},
      <String, String>{'name': 'France', 'code': '+33'},
      <String, String>{'name': 'Gabon', 'code': '+241'},
      <String, String>{'name': 'Gambia', 'code': '+220'},
      <String, String>{'name': 'Georgia', 'code': '+995'},
      <String, String>{'name': 'Germany', 'code': '+49'},
      <String, String>{'name': 'Ghana', 'code': '+233'},
      <String, String>{'name': 'Greece', 'code': '+30'},
      <String, String>{'name': 'Grenada', 'code': '+1-473'},
      <String, String>{'name': 'Guatemala', 'code': '+502'},
      <String, String>{'name': 'Guinea', 'code': '+224'},
      <String, String>{'name': 'Guinea-Bissau', 'code': '+245'},
      <String, String>{'name': 'Guyana', 'code': '+592'},
      <String, String>{'name': 'Haiti', 'code': '+509'},
      <String, String>{'name': 'Honduras', 'code': '+504'},
      <String, String>{'name': 'Hungary', 'code': '+36'},
      <String, String>{'name': 'Iceland', 'code': '+354'},
      <String, String>{'name': 'India', 'code': '+91'},
      <String, String>{'name': 'Indonesia', 'code': '+62'},
      <String, String>{'name': 'Iran', 'code': '+98'},
      <String, String>{'name': 'Iraq', 'code': '+964'},
      <String, String>{'name': 'Ireland', 'code': '+353'},
      <String, String>{'name': 'Israel', 'code': '+972'},
      <String, String>{'name': 'Italy', 'code': '+39'},
      <String, String>{'name': 'Jamaica', 'code': '+1-876'},
      <String, String>{'name': 'Japan', 'code': '+81'},
      <String, String>{'name': 'Jordan', 'code': '+962'},
      <String, String>{'name': 'Kazakhstan', 'code': '+7'},
      <String, String>{'name': 'Kenya', 'code': '+254'},
      <String, String>{'name': 'Kiribati', 'code': '+686'},
      <String, String>{'name': 'Korea, North', 'code': '+850'},
      <String, String>{'name': 'Korea, South', 'code': '+82'},
      <String, String>{'name': 'Kosovo', 'code': '+383'},
      <String, String>{'name': 'Kuwait', 'code': '+965'},
      <String, String>{'name': 'Kyrgyzstan', 'code': '+996'},
      <String, String>{'name': 'Laos', 'code': '+856'},
      <String, String>{'name': 'Latvia', 'code': '+371'},
      <String, String>{'name': 'Lebanon', 'code': '+961'},
      <String, String>{'name': 'Lesotho', 'code': '+266'},
      <String, String>{'name': 'Liberia', 'code': '+231'},
      <String, String>{'name': 'Libya', 'code': '+218'},
      <String, String>{'name': 'Liechtenstein', 'code': '+423'},
      <String, String>{'name': 'Lithuania', 'code': '+370'},
      <String, String>{'name': 'Luxembourg', 'code': '+352'},
      <String, String>{'name': 'Madagascar', 'code': '+261'},
      <String, String>{'name': 'Malawi', 'code': '+265'},
      <String, String>{'name': 'Malaysia', 'code': '+60'},
      <String, String>{'name': 'Maldives', 'code': '+960'},
      <String, String>{'name': 'Mali', 'code': '+223'},
      <String, String>{'name': 'Malta', 'code': '+356'},
      <String, String>{'name': 'Marshall Islands', 'code': '+692'},
      <String, String>{'name': 'Mauritania', 'code': '+222'},
      <String, String>{'name': 'Mauritius', 'code': '+230'},
      <String, String>{'name': 'Mexico', 'code': '+52'},
      <String, String>{'name': 'Micronesia', 'code': '+691'},
      <String, String>{'name': 'Moldova', 'code': '+373'},
      <String, String>{'name': 'Monaco', 'code': '+377'},
      <String, String>{'name': 'Mongolia', 'code': '+976'},
      <String, String>{'name': 'Montenegro', 'code': '+382'},
      <String, String>{'name': 'Morocco', 'code': '+212'},
      <String, String>{'name': 'Mozambique', 'code': '+258'},
      <String, String>{'name': 'Myanmar', 'code': '+95'},
      <String, String>{'name': 'Namibia', 'code': '+264'},
      <String, String>{'name': 'Nauru', 'code': '+674'},
      <String, String>{'name': 'Nepal', 'code': '+977'},
      <String, String>{'name': 'Netherlands', 'code': '+31'},
      <String, String>{'name': 'New Zealand', 'code': '+64'},
      <String, String>{'name': 'Nicaragua', 'code': '+505'},
      <String, String>{'name': 'Niger', 'code': '+227'},
      <String, String>{'name': 'Nigeria', 'code': '+234'},
      <String, String>{'name': 'North Macedonia', 'code': '+389'},
      <String, String>{'name': 'Norway', 'code': '+47'},
      <String, String>{'name': 'Oman', 'code': '+968'},
      <String, String>{'name': 'Pakistan', 'code': '+92'},
      <String, String>{'name': 'Palau', 'code': '+680'},
      <String, String>{'name': 'Palestine', 'code': '+970'},
      <String, String>{'name': 'Panama', 'code': '+507'},
      <String, String>{'name': 'Papua New Guinea', 'code': '+675'},
      <String, String>{'name': 'Paraguay', 'code': '+595'},
      <String, String>{'name': 'Peru', 'code': '+51'},
      <String, String>{'name': 'Philippines', 'code': '+63'},
      <String, String>{'name': 'Poland', 'code': '+48'},
      <String, String>{'name': 'Portugal', 'code': '+351'},
      <String, String>{'name': 'Qatar', 'code': '+974'},
      <String, String>{'name': 'Romania', 'code': '+40'},
      <String, String>{'name': 'Russia', 'code': '+7'},
      <String, String>{'name': 'Rwanda', 'code': '+250'},
      <String, String>{'name': 'Saint Kitts and Nevis', 'code': '+1-869'},
      <String, String>{'name': 'Saint Lucia', 'code': '+1-758'},
      <String, String>{'name': 'Saint Vincent and the Grenadines', 'code': '+1-784'},
      <String, String>{'name': 'Samoa', 'code': '+685'},
      <String, String>{'name': 'San Marino', 'code': '+378'},
      <String, String>{'name': 'Sao Tome and Principe', 'code': '+239'},
      <String, String>{'name': 'Saudi Arabia', 'code': '+966'},
      <String, String>{'name': 'Senegal', 'code': '+221'},
      <String, String>{'name': 'Serbia', 'code': '+381'},
      <String, String>{'name': 'Seychelles', 'code': '+248'},
      <String, String>{'name': 'Sierra Leone', 'code': '+232'},
      <String, String>{'name': 'Singapore', 'code': '+65'},
      <String, String>{'name': 'Slovakia', 'code': '+421'},
      <String, String>{'name': 'Slovenia', 'code': '+386'},
      <String, String>{'name': 'Solomon Islands', 'code': '+677'},
      <String, String>{'name': 'Somalia', 'code': '+252'},
      <String, String>{'name': 'South Africa', 'code': '+27'},
      <String, String>{'name': 'South Sudan', 'code': '+211'},
      <String, String>{'name': 'Spain', 'code': '+34'},
      <String, String>{'name': 'Sri Lanka', 'code': '+94'},
      <String, String>{'name': 'Sudan', 'code': '+249'},
      <String, String>{'name': 'Suriname', 'code': '+597'},
      <String, String>{'name': 'Sweden', 'code': '+46'},
      <String, String>{'name': 'Switzerland', 'code': '+41'},
      <String, String>{'name': 'Syria', 'code': '+963'},
      <String, String>{'name': 'Taiwan', 'code': '+886'},
      <String, String>{'name': 'Tajikistan', 'code': '+992'},
      <String, String>{'name': 'Tanzania', 'code': '+255'},
      <String, String>{'name': 'Thailand', 'code': '+66'},
      <String, String>{'name': 'Togo', 'code': '+228'},
      <String, String>{'name': 'Tonga', 'code': '+676'},
      <String, String>{'name': 'Trinidad and Tobago', 'code': '+1-868'},
      <String, String>{'name': 'Tunisia', 'code': '+216'},
      <String, String>{'name': 'Turkey', 'code': '+90'},
      <String, String>{'name': 'Turkmenistan', 'code': '+993'},
      <String, String>{'name': 'Tuvalu', 'code': '+688'},
      <String, String>{'name': 'Uganda', 'code': '+256'},
      <String, String>{'name': 'Ukraine', 'code': '+380'},
      <String, String>{'name': 'United Arab Emirates', 'code': '+971'},
      <String, String>{'name': 'United Kingdom', 'code': '+44'},
      <String, String>{'name': 'United States', 'code': '+1'},
      <String, String>{'name': 'Uruguay', 'code': '+598'},
      <String, String>{'name': 'Uzbekistan', 'code': '+998'},
      <String, String>{'name': 'Vanuatu', 'code': '+678'},
      <String, String>{'name': 'Vatican City', 'code': '+379'},
      <String, String>{'name': 'Venezuela', 'code': '+58'},
      <String, String>{'name': 'Vietnam', 'code': '+84'},
      <String, String>{'name': 'Yemen', 'code': '+967'},
      <String, String>{'name': 'Zambia', 'code': '+260'},
      <String, String>{'name': 'Zimbabwe', 'code': '+263'}
    ]
  };
  static String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Enter a valid email';
    }
    if (!email.contains(AppStrings.emailRegex)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? passWord) {
    print('hi 1');
    if (!passWord!.contains(AppStrings.passwordRegex)) {
      print('hi 2');
      return 'Password must be at least 8 characters long and include at least one lowercase letter, one uppercase letter, and one digit';
    }
    print('hi 3');
    return null;
  }

  static String? validateName(String? userName) {
    if (userName!.length <= 3) {
      return 'Enter a valid name';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone!.length < 6 || phone.length > 12) {
      return 'Enter a valid phone number';
    }
    return null;
  }
}
