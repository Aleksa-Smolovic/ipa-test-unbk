import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/models/announcement.dart';
import 'package:unbroken/models/user.dart';
import 'package:unbroken/services/auth_service.dart';
import 'package:unbroken/util/error_messages.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final List<Announcement> _announcements = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 0;
  static const int _pageSize = 10;
  bool _hasMoreData = true;

  final apiService = getIt<ApiService>();

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(ErrorMessages.defaultMessage),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _loadAnnouncements() async {
    try {
      final response = await apiService
          .get("${ApiEndpoints.announcements}&size=$_pageSize&page=$_page");
      List<Announcement> newAnnouncements =
          response.map<Announcement>((s) => Announcement.fromJson(s)).toList();
      setState(() {
        _page++;
        if (newAnnouncements.length < _pageSize) {
          _hasMoreData = false;
        }
        _announcements.addAll(newAnnouncements);
      });
    } on ApiError catch (e) {
      _showErrorMessage();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
    _scrollController.addListener(() {
      if (_hasMoreData &&
          _scrollController.position.maxScrollExtent ==
              _scrollController.offset) {
        _loadAnnouncements();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Announcements',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Image.asset('assets/images/logo.png', width: 150)
              ],
            ),
            automaticallyImplyLeading: false),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            MembershipBanner(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _announcements.length + 1,
                itemBuilder: (context, index) {
                  if (index < _announcements.length) {
                    return AnnouncementListItem(item: _announcements[index]);
                  } else {
                    if (_hasMoreData) {
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()));
                    }
                  }
                },
              ),
            )
          ],
        ));
  }
}

class AnnouncementListItem extends StatefulWidget {
  final Announcement item;

  const AnnouncementListItem({super.key, required this.item});

  @override
  State<AnnouncementListItem> createState() => _AnnouncementListItemState();
}

class _AnnouncementListItemState extends State<AnnouncementListItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isTextLong = widget.item.text.length > 100;
    final TextStyle textStyle = GoogleFonts.poppins(
        color: Colors.grey.shade600,
        fontSize: 14,
        fontWeight: FontWeight.normal);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xff141414),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.item.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              if (isTextLong)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 2.0),
          Row(
            children: [
              const Icon(Icons.access_time,
                  color: Color(0xFF1CA7D1), size: 16.0),
              const SizedBox(width: 4.0),
              Text(
                widget.item.createdAt,
                style: textStyle,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          AnimatedCrossFade(
            firstChild: Text(
              widget.item.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            secondChild: Text(
              widget.item.text,
              style: textStyle,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class MembershipBanner extends StatelessWidget {
  MembershipBanner({super.key});

  final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  final authService = getIt<AuthService>();

  Future<User> _getUserData() async {
    return await authService.getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.membershipValidFrom != null) {
          bool hasMembershipExpired = _dateFormat
              .parse(snapshot.data!.membershipValidTo!)
              .isBefore(DateTime.now());
          return Container(
            width: double.infinity,
            color: hasMembershipExpired
                ? const Color(0xffDA0000)
                : const Color(0xFF0A3037),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Membership valid from ${snapshot.data!.membershipValidFrom!} to ${snapshot.data!.membershipValidTo!}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
