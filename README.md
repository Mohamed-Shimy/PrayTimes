# PrayTime

<p align="center">
  <img height="200" src="web/logo.png" />
</p>

![Swift Version][image-1] [![Swift Package Manager compatible][image-2]][1]


# Description

​Daily prayer (salah) times, fixed by Qur'an and Hadith,
are bound to the apparent motion of the Sun on the sky.

Zuhr prayer time enters when the Sun circle passes to the
west, Fajr prayer ends when the Sun starts to raise, Magrib
starts when the Sun sets completely.
Except Imam Abu Hanifa, Asr time starts when the shadow
elongates one object's length from its noon length (Asr-I).
Abu Hanifa rules that the shadow has to stretch two object's
length (Asr-II). It may be safer to complete Zuhr prayer before
Asr-I and perform the Asr after Asr-II; however in difficulty,
one may perform a missed Zuhr prayer until Asr-II without Qada
and then perform Asr prayer after Asr-II.

Fajr/Isha timings are predicated on the observation of the
onset/vanishing of the twilight on the horizon, which is dependent
both on the observer as well as the atmospheric conditions.
Therefore it cannot be determined precisely by computation.
Calculated timings are conjectural relying on certain assumptions,
which can vary for each country. If observation is not possible,
the indeterminate region should be taken into consideration, by
starting to fast before the Sun's vertical angle reaches -18º and
performing Fajr prayer after -15º. Similarly, Maghrib prayer should
be completed before -15º and Isha performed after -17º. Abu Hanifa
defines Isha as the end of the red glow on the sky, which occurs
between -9º and -12º. Considering this, it will be safer to finish
Maghrib prayer before -9º.

Prayer calendars may include a safety margin for each calculated timing,
which should be taken into account.

Daytime is coded as the fasting period, namely between Fajr and Maghrib
and the night as between Maghrib and Fajr.

Isha prayer should rather be completed before the first third of the night
or until midnight at most.

Because the eccentricity and obliquity of the Earth's motion, the Zuhr time
drifts 30 minutes within the year; so do the other timings since they are
calculated relative to Zuhr.

Prayer is not allowed when the Sun is near the horizon (elevation < 5°)
and its rays are yellowish.

Prayer is not allowed when the Sun is at highest.
Safe is not to pray after the center of the daytime
until Zuhr.

At high latitudes when the Isha enters very late,
it may be limited to one-third or one-half of the night.
Similarly, when the twilight persists, Fajr may be
limited to 30 minutes after the middle of sunset/sunrise
interval.

At higher latitudes when the Sun does not rise/set
or when the day/night periods are too small for prayer,
the timings may be fixed such that a convenient period
(45~60 minutes) is available for each prayer.


## References

[Alperen.com][spec]

[spec]:http://alperen.cepmuvakkit.com/alperen/makale/index.htm#Mekruh

[PrayTimes.org][spec]

[spec]:http://praytimes.org

[Objective-C Source Code][spec]

[spec]:http://praytimes.org/code/git/?a=tree&p=PrayTimes&hb=HEAD&f=v1/objc



## Author

Mohamed Shimy, msh.work@outlook.sa

## License

PrayTimes is available under the MIT license. See the LICENSE file for more info.

[1]:	https://github.com/apple/swift-package-manager

[image-1]:	https://img.shields.io/badge/Swift-5.9-F16D39.svg?style=flat
[image-2]:	https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg


