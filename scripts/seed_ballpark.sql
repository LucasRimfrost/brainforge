-- seed_ballpark.sql
-- Ballpark (daily estimation) challenges: first batch, 2026-09-16 → 2026-10-15
-- (14 days of archive, 2026-09-30, and 15 days ahead). About half tech and
-- computing, half science and world facts. See docs/games/ballpark.md §9.
--
-- Rules for every row: one stable, verifiable number; an explicit unit in the
-- question; 0 < answer <= 1e15 with at most 3 decimals; no calendar years.
-- Tolerance: 5% for well-known exact figures, 10% default, 20% for fuzzy ones.
-- Each row carries a short source note as a comment.
--
-- TODO: the rest of the first batch (through 2026-12-31, ~120 questions total).

INSERT INTO ballpark_challenges (title, question, unit, answer, decimals, tolerance_pct, difficulty, explanation, source_url, max_attempts, scheduled_date)
VALUES

-- ── September 2026 ──────────────────────────────────────────────────────────

-- Source: RFC 4291 §2 (IPv6 addresses are 128-bit identifiers); 128 / 8 = 16.
('IPv6 Address Size',
 'How many bytes long is a single IPv6 address?',
 'bytes', 16, 0, 5, 'easy',
 'An IPv6 address is 128 bits, which is 16 bytes. That is four times the 32 bits of IPv4 and enough for about 3.4 × 10^38 addresses.',
 'https://www.rfc-editor.org/rfc/rfc4291', 5, '2026-09-16'),

-- Source: Gray's Anatomy / standard human anatomy texts: 206 bones in a typical adult.
('Adult Skeleton',
 'How many bones are in a typical adult human body?',
 'bones', 206, 0, 5, 'easy',
 'A typical adult has 206 bones. Newborns have around 270, but many of them, such as those in the skull and the base of the spine, fuse as the body grows.',
 'https://www.britannica.com/science/human-skeleton', 5, '2026-09-17'),

-- Source: RFC 894 (IP over Ethernet): maximum data field 1500 octets.
('Ethernet MTU',
 'What is the standard maximum payload (MTU) of an Ethernet frame, in bytes?',
 'bytes', 1500, 0, 5, 'medium',
 'Classic Ethernet carries at most 1500 bytes of payload per frame. Larger "jumbo frames" exist, but 1500 is still the default MTU on most networks and the reason many VPN tunnels need tuning.',
 'https://www.rfc-editor.org/rfc/rfc894', 5, '2026-09-18'),

-- Source: NASA Moon fact sheet: mean Earth–Moon distance 384,400 km.
('To the Moon',
 'What is the average distance from the Earth to the Moon, in kilometres?',
 'km', 384400, 0, 10, 'medium',
 'The Moon orbits at an average of about 384,400 km. Radio signals take roughly 1.28 seconds to cover it, which is why Apollo conversations had a noticeable delay.',
 'https://nssdc.gsfc.nasa.gov/planetary/factsheet/moonfact.html', 5, '2026-09-19'),

-- Source: FIPS 180-4: SHA-256 produces a 256-bit digest; 256 / 4 bits per hex digit = 64.
('SHA-256 in Hex',
 'How many hexadecimal characters does a SHA-256 hash have when written out?',
 'characters', 64, 0, 5, 'easy',
 'SHA-256 outputs 256 bits. Each hex digit encodes 4 bits, so the familiar hash string is 64 characters long.',
 'https://csrc.nist.gov/pubs/fips/180-4/upd1/final', 5, '2026-09-20'),

-- Source: IUPAC periodic table: 118 named elements (the 7th period was completed in 2016).
('Periodic Table',
 'How many chemical elements have been officially named on the periodic table?',
 'elements', 118, 0, 5, 'easy',
 'There are 118 confirmed elements, ending with oganesson (Og, element 118). The four most recent names were approved by IUPAC in 2016, completing the seventh row.',
 'https://iupac.org/what-we-do/periodic-table-of-elements/', 5, '2026-09-21'),

-- Source: RFC 9293 (TCP): port numbers are 16-bit fields, so the highest is 2^16 - 1.
('Highest Port',
 'What is the highest valid TCP port number?',
 'port number', 65535, 0, 5, 'easy',
 'TCP and UDP ports are 16-bit numbers, so they run from 0 to 2^16 - 1 = 65,535. Ports below 1024 are the traditional "well-known" ports.',
 'https://www.rfc-editor.org/rfc/rfc9293', 5, '2026-09-22'),

-- Source: Encyclopaedia Britannica, piano: the standard modern piano has 88 keys.
('Piano Keys',
 'How many keys does a standard modern piano have?',
 'keys', 88, 0, 5, 'easy',
 'A standard piano has 88 keys (52 white and 36 black), spanning a little over seven octaves from A0 to C8.',
 'https://www.britannica.com/art/piano', 5, '2026-09-23'),

-- Source: The Unicode Standard, ch. 2 "Code Points": U+0000..U+10FFFF = 1,114,112 code points.
('Unicode Codespace',
 'How many code points are there in the Unicode codespace (U+0000 to U+10FFFF)?',
 'code points', 1114112, 0, 10, 'hard',
 'Unicode has 17 planes of 65,536 code points each, which gives 1,114,112. UTF-16''s surrogate pairs are the reason the space stops at U+10FFFF.',
 'https://www.unicode.org/versions/latest/', 5, '2026-09-24'),

-- Source: NHGRI / NIH: human somatic cells have 23 pairs = 46 chromosomes.
('Chromosome Count',
 'How many chromosomes are in a typical human body cell?',
 'chromosomes', 46, 0, 5, 'easy',
 'Human body cells carry 46 chromosomes in 23 pairs: one set from each parent. Egg and sperm cells carry just 23.',
 'https://www.genome.gov/about-genomics/fact-sheets/Karyotype-Fact-Sheet', 5, '2026-09-25'),

-- Source: RFC 1035 §2.3.4: labels are 63 octets or less.
('DNS Label Limit',
 'What is the maximum length of a single DNS label (one part of a domain name between dots), in characters?',
 'characters', 63, 0, 10, 'medium',
 'Each DNS label is length-prefixed with a single byte whose top two bits are reserved, which leaves 6 bits: at most 63 characters per label.',
 'https://www.rfc-editor.org/rfc/rfc1035', 5, '2026-09-26'),

-- Source: World Athletics / IAAF rules: marathon distance 42.195 km.
('Marathon Distance',
 'How long is an official marathon, in kilometres?',
 'km', 42.195, 3, 5, 'easy',
 'The marathon is exactly 42.195 km (26 miles 385 yards). The distance was fixed after the 1908 London Olympics course, which ran from Windsor Castle to the royal box.',
 'https://worldathletics.org/', 5, '2026-09-27'),

-- Source: RFC 768 (UDP): header is four 16-bit fields = 8 octets.
('UDP Header',
 'How many bytes long is a UDP header?',
 'bytes', 8, 0, 10, 'medium',
 'A UDP header is just 8 bytes: source port, destination port, length and checksum, 16 bits each. Compare that with at least 20 bytes for TCP.',
 'https://www.rfc-editor.org/rfc/rfc768', 5, '2026-09-28'),

-- Source: United Nations, "Member States": 193 members (South Sudan joined last, in 2011).
('UN Members',
 'How many member states does the United Nations have?',
 'countries', 193, 0, 5, 'medium',
 'The UN has 193 member states. The most recent to join was South Sudan in 2011; the Holy See and Palestine are non-member observer states.',
 'https://www.un.org/en/about-us/member-states', 5, '2026-09-29'),

-- Source: SI definition of the metre: c = 299,792,458 m/s exactly; 0.299792458 m per ns = 29.98 cm.
('Nanosecond of Light',
 'How far does light travel in a vacuum in one nanosecond, in centimetres?',
 'cm', 29.98, 2, 5, 'medium',
 'Light covers about 29.98 cm per nanosecond, roughly a foot. Grace Hopper famously handed out pieces of wire this long to show why signals, and computers, can only be so fast.',
 'https://www.bipm.org/en/si-base-units/metre', 5, '2026-09-30'),

-- ── October 2026 ────────────────────────────────────────────────────────────

-- Source: Societe d'Exploitation de la Tour Eiffel: 330 m including antennas (since 2022).
('Eiffel Tower',
 'How tall is the Eiffel Tower including its antennas, in metres?',
 'metres', 330, 0, 10, 'easy',
 'The tower stands about 330 m tall with its antennas; the iron structure itself is about 300 m. Its height also changes by several centimetres as the metal expands in summer heat.',
 'https://www.toureiffel.paris/en/the-monument/key-figures', 5, '2026-10-01'),

-- Source: RFC 791 (IPv4): addresses are 32 bits, so 2^32 = 4,294,967,296 addresses.
('IPv4 Address Space',
 'How many distinct IPv4 addresses are there in total?',
 'addresses', 4294967296, 0, 10, 'medium',
 'IPv4 addresses are 32 bits, giving 2^32 ≈ 4.29 billion addresses. Large reserved ranges and far more devices than that are why NAT and IPv6 exist.',
 'https://www.rfc-editor.org/rfc/rfc791', 5, '2026-10-02'),

-- Source: standard physics references (e.g. Britannica, "Sound"): dry air at 20 °C ≈ 343 m/s.
('Speed of Sound',
 'What is the speed of sound in dry air at 20 °C, in metres per second?',
 'm/s', 343, 0, 10, 'medium',
 'Sound travels at about 343 m/s in air at 20 °C, roughly 1 km every 3 seconds. That is why counting the seconds after a lightning flash tells you how far away the storm is.',
 'https://www.britannica.com/science/sound-physics', 5, '2026-10-03'),

-- Source: RFC 20 (ASCII): printable characters are 0x20 (space) to 0x7E = 95 characters.
('Printable ASCII',
 'How many printable characters (including the space) does 7-bit ASCII define?',
 'characters', 95, 0, 10, 'hard',
 'ASCII has 128 codes: 33 are control characters (0–31 and 127, DEL), leaving 95 printable ones from the space (32) to the tilde (126).',
 'https://www.rfc-editor.org/rfc/rfc20', 5, '2026-10-04'),

-- Source: 2020 China–Nepal survey, announced December 2020: 8,848.86 m.
('Top of the World',
 'How high is the summit of Mount Everest above sea level, in metres?',
 'metres', 8848.86, 2, 5, 'medium',
 'The official height is 8,848.86 m, from a joint China–Nepal survey announced in 2020. It is the highest point above sea level, but because of the equatorial bulge the summit of Chimborazo in Ecuador is farther from the centre of the Earth.',
 'https://www.britannica.com/place/Mount-Everest', 5, '2026-10-05'),

-- Source: two's complement: the largest signed 32-bit integer is 2^31 - 1 = 2,147,483,647.
('Int32 Max',
 'What is the largest value a signed 32-bit integer can hold?',
 'number', 2147483647, 0, 10, 'medium',
 'A signed 32-bit integer uses one bit for the sign, so its maximum is 2^31 - 1 = 2,147,483,647. Adding 1 overflows to -2,147,483,648, a classic source of bugs.',
 'https://learn.microsoft.com/en-us/cpp/cpp/data-type-ranges', 5, '2026-10-06'),

-- Source: Smithsonian Ocean / Britannica: an octopus has three hearts.
('Octopus Hearts',
 'How many hearts does an octopus have?',
 'hearts', 3, 0, 10, 'easy',
 'An octopus has three hearts: two pump blood through the gills and one pumps it around the body. Its blood is blue because it uses copper-based hemocyanin to carry oxygen.',
 'https://ocean.si.edu/ocean-life/invertebrates/octopus', 5, '2026-10-07'),

-- Source: RFC 9562 (UUIDs): a UUID is a 128-bit value.
('UUID Size',
 'How many bits long is a UUID?',
 'bits', 128, 0, 5, 'easy',
 'A UUID is 128 bits, usually written as 32 hex digits in five groups. A random v4 UUID has 122 random bits, so collisions are practically impossible.',
 'https://www.rfc-editor.org/rfc/rfc9562', 5, '2026-10-08'),

-- Source: IAU 2012 (AU = 149,597,870,700 m exactly) / c = 299,792,458 m/s: 499.0 s.
('Sunlight Delay',
 'How many seconds does light take to travel one astronomical unit (the average Earth–Sun distance)?',
 'seconds', 499, 0, 5, 'medium',
 'Light needs about 499 seconds, or 8 minutes 19 seconds, to cross one astronomical unit. The sunlight you see is always slightly more than 8 minutes old.',
 'https://www.iau.org/static/resolutions/IAU2012_English.pdf', 5, '2026-10-09'),

-- Source: RFC 8200 §5 (IPv6): every link must have an MTU of 1280 octets or greater.
('IPv6 Minimum MTU',
 'What is the minimum MTU every IPv6 link must support, in bytes?',
 'bytes', 1280, 0, 10, 'hard',
 'IPv6 requires every link to carry packets of at least 1280 bytes. Routers never fragment IPv6 packets, so senders rely on this floor and on path MTU discovery.',
 'https://www.rfc-editor.org/rfc/rfc8200', 5, '2026-10-10'),

-- Source: FIDE Laws of Chess: 16 pawn moves + 4 knight moves = 20 legal first moves.
('Opening Options',
 'How many different legal first moves does White have in chess?',
 'moves', 20, 0, 10, 'medium',
 'White has 20 possible first moves: each of the 8 pawns can move one or two squares (16 moves), and each knight has two squares to go to (4 moves).',
 'https://handbook.fide.com/', 5, '2026-10-11'),

-- Source: IEEE 802 (EUI-48): a MAC address is 48 bits.
('MAC Address Size',
 'How many bits long is a standard Ethernet MAC address?',
 'bits', 48, 0, 5, 'easy',
 'An Ethernet MAC address is 48 bits, written as six pairs of hex digits. The first 24 bits usually identify the manufacturer (the OUI).',
 'https://standards.ieee.org/products-programs/regauth/', 5, '2026-10-12'),

-- Source: NASA Earth fact sheet: equatorial radius 6,378.137 km → circumference ≈ 40,075 km.
('Around the Equator',
 'What is the circumference of the Earth at the equator, in kilometres?',
 'km', 40075, 0, 10, 'medium',
 'The equator is about 40,075 km around. The metre was originally defined so that the distance from the pole to the equator would be 10,000 km, which is why the number is so close to 40,000.',
 'https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html', 5, '2026-10-13'),

-- Source: SI definition of the metre: c = 299,792,458 m/s; 1000 m / c = 3.336 µs.
('Kilometre of Light',
 'How long does light take to travel 1 km in a vacuum, in microseconds?',
 'µs', 3.336, 3, 5, 'hard',
 'Light needs about 3.336 µs per kilometre in a vacuum, and about 5 µs in optical fibre. That is why a round trip across an ocean always costs tens of milliseconds.',
 'https://www.bipm.org/en/si-base-units/metre', 5, '2026-10-14'),

-- Source: American Dental Association: adults have 32 permanent teeth (including wisdom teeth).
('Adult Teeth',
 'How many permanent teeth does a full adult set have, including wisdom teeth?',
 'teeth', 32, 0, 10, 'easy',
 'A full adult set has 32 teeth, including four wisdom teeth. Children have just 20 baby teeth.',
 'https://www.mouthhealthy.org/', 5, '2026-10-15');
