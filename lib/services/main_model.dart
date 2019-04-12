import 'package:scoped_model/scoped_model.dart';

import './partner_list_service.dart';
import './reward_list_service.dart';
import './user_service.dart';
import './news_service.dart';
import './ads_service.dart';
import './claim_service.dart';
import './statement_service.dart';

class MainModel extends Model
    with
        PartnerListService,
        RewardListService,
        UserService,
        NewsService,
        AdsService,
        ClaimService,
        FilterService {}
