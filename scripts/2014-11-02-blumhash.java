/**
 * http://programmingpraxis.com/2014/09/26/blums-mental-hash/
 *
 * Blum’s Mental Hash
 *
 * Your task today is to implement Manuel Blum's mental hashing algorithm, available here, for mapping a web site name to a password.
 * http://www.scilogs.com/hlf/mental-cryptography-and-good-passwords/
 *
 */
public class BlumHash {

    private static final String EXAMPLE_MAP = "83712345678901234567890123";
    private static final String EXAMPLE_PERMUTATION = "0298736514";

    @Test
    public void testBlumHash() throws Exception {
        System.out.println(blumHash("Programmingpraxis A to z", EXAMPLE_MAP, EXAMPLE_PERMUTATION));
        Assertions.assertThat(blumHash("abc", EXAMPLE_MAP, EXAMPLE_PERMUTATION)).isEqualTo("103");
    }

    public static String blumHash(String siteInput, String map, String permutation) {
        String hash = "";
        String site = siteInput.replaceAll("[^a-zA-Z]", "").toLowerCase();
        int bi = -1;
        for (int i = 1; i <= site.length(); i++) {
            if (i == 1) {
                bi = g((f(site.charAt(i - 1), map) + f(site.charAt(site.length() - 1), map)) % 10, permutation);
            } else {
                bi = g((bi + f(site.charAt(i - 1), map)) % 10, permutation);
            }
            hash += bi;
        }
        System.out.println(siteInput);
        System.out.println(hash);
        return hash;
    }

    private static int g(int number, String permutation) {
        return Integer.valueOf((permutation + permutation.charAt(0)).substring(
            (permutation).indexOf("" + number) + 1,
            (permutation).indexOf("" + number) + 2));
    }

    private static int f(Character c, String map) {
        return Integer.valueOf(map.substring((int) c - (int) 'a', (int) c - (int) 'a' + 1));
    }
}
