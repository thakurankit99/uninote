import { Link } from "@mui/joy";
import { DotIcon } from "lucide-react";
import MobileHeader from "@/components/MobileHeader";
import { useTranslate } from "@/utils/i18n";

const About = () => {
  const t = useTranslate();

  return (
    <section className="@container w-full max-w-5xl min-h-full flex flex-col justify-start items-center sm:pt-3 md:pt-6 pb-8">
      <MobileHeader />
      <div className="w-full px-4 sm:px-6">
        <div className="w-full shadow flex flex-col justify-start items-start px-4 py-3 rounded-xl bg-white dark:bg-zinc-800 text-black dark:text-gray-300">
          <a href="https://www.usememos.com" target="_blank">
            <img className="w-auto h-12" src="https://unihubconnect.com/images/favicon/og-image.png" alt="unihub connect" />
          </a>
          <p className="text-base">{t("about.description")}</p>
          <div className="mt-1 flex flex-row items-center flex-wrap">
            <Link underline="always" href="https://unihubconnect.com/" target="_blank">
              {t("about.official-website")}
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;