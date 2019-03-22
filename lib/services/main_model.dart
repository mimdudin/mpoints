import 'package:scoped_model/scoped_model.dart';

import './partner_list_service.dart';
import './reward_list_service.dart';


class MainModel extends Model with PartnerListService, RewardListService {}